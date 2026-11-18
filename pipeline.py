import os
import time
import logging
import smtplib
from pathlib import Path
from datetime import datetime
from email.mime.text import MIMEText
import requests
import pandas as pd
from dotenv import load_dotenv

from data_fetcher import fetch_sales_advanced, fetch_customers_advanced, fetch_products_advanced
from transform import clean_data_advanced, merge_datasets, calculate_weekly_aggregates, calculate_kpis
from visualize_export import export_results

load_dotenv()

# Väljundfailide asukoha loomine. 
Path("output").mkdir(parents=True, exist_ok=True)
CACHE_DIR = Path("cache")
CACHE_DIR.mkdir(parents=True, exist_ok=True)

#Loggeri konfiguratsioon
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler(f"output/pipeline_{datetime.now():%Y%m%d}.log", encoding="utf-8"),
        logging.StreamHandler(),
    ],
    force=True,
)

# Teadete saatmine peakasutajale/vastutavale isikule ETL päringu staatuse kohta. 
def send_notification(subject: str, message: str, is_error: bool = False):
    """Saadab teavituse Google Chati ja/või e-mailile."""
    prefix = "🚨 VIGA" if is_error else "✅ ÕNNESTUS"
    sent = False

    if webhook := os.getenv("GOOGLE_CHAT_WEBHOOK_URL"):
        try:
            requests.post(webhook, json={"text": f"*{prefix}: {subject}*\n{message}"}, timeout=10).raise_for_status()
            logging.info("Google Chat teavitus saadetud.")
            sent = True
        except Exception as e:
            logging.error(f"Google Chat viga: {e}")

    smtp_cfg = [os.getenv(k) for k in ("SMTP_SERVER", "SMTP_USER", "SMTP_PASSWORD", "NOTIFICATION_EMAIL")]
    if all(smtp_cfg):
        try:
            msg = MIMEText(message, "plain", "utf-8")
            msg["Subject"], msg["From"], msg["To"] = f"{prefix} - {subject}", smtp_cfg, smtp_cfg
            with smtplib.SMTP(smtp_cfg, int(os.getenv("SMTP_PORT", 587))) as server:
                server.starttls()
                server.login(smtp_cfg, smtp_cfg)
                server.send_message(msg)
            logging.info(f"E-mail saadetud: {smtp_cfg}")
            sent = True
        except Exception as e:
            logging.error(f"E-maili viga: {e}")

    if not sent:
        logging.info(f"[TEAVITUSE SIMULATSIOON] {prefix} | {subject} -> {message}")

# ETL pipeline retry konfiguratsioon - 3 korda, siis teavitus ebaõnnestumisest. 
def run_step(step_name: str, error_title: str, func, retries: int = 1):
    """Käivitab etapi koos korduskatsete ja ühtse veahaldusega."""
    logging.info(f"{step_name} alustatud")
    for attempt in range(1, retries + 1):
        try:
            return func()
        except Exception as e:
            logging.warning(f"{step_name} katse {attempt}/{retries} ebaõnnestus: {e}")
            if attempt == retries:
                err_msg = f"{step_name} nurjus: {e}"
                logging.error(err_msg)
                send_notification(error_title, err_msg, is_error=True)
                raise RuntimeError(err_msg) from e
            time.sleep(2 ** attempt)

# ETL pipeline käsklused 
def run_pipeline(start_date: str = None, end_date: str = None, output_dir: str = "output"):
    """Kogu ETL protsess: Extract -> Transform -> Export."""
    run_timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    logging.info(f"Pipeline algab | Käivitusaeg: {run_timestamp}")
    
    used_fallback = False
    data_source_log = ""

    # 1. EXTRACT - koos automaatse vahemälu, fallbacki ja logimisega
    def fetch_from_supabase():
        sales = fetch_sales_advanced(start_date=start_date, end_date=end_date)
        customers, products = fetch_customers_advanced(), fetch_products_advanced()
        if sales.empty:
            raise ValueError("Müügiandmete tabel (df_sales) on tühi!")
        
        # Kohalikke varufailide uuendamine tagavara fallback tarbeks
        sales.to_csv(CACHE_DIR / "sales_backup.csv", index=False)
        customers.to_csv(CACHE_DIR / "customers_backup.csv", index=False)
        products.to_csv(CACHE_DIR / "products_backup.csv", index=False)
        
        saved_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        logging.info(f"Varufailid uuendatud kell {saved_at}.")
        return sales, customers

    try:
        df_sales, df_customers = run_step(
            "Etapp 1: Extract (Supabase)", "ETL Extract Hoiatus", fetch_from_supabase, retries=3
        )
        fetch_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        data_source_log = f"Supabase (otseühendus) | Andmed päritud: {fetch_time}"
        logging.info(f"Kasutati: {data_source_log} | Read: {len(df_sales)} müüki, {len(df_customers)} klienti.")
        
    except RuntimeError as e:
        fallback_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        logging.warning(f"Supabase pole kättesaadav kell {fallback_time} ({e}). Käivitan fallbacki kohalikest failidest...")
        
        sales_backup = CACHE_DIR / "sales_backup.csv"
        customers_backup = CACHE_DIR / "customers_backup.csv"

        if sales_backup.exists() and customers_backup.exists():
            # Kontrollime failide viimase muutmise aega (kui vanad on varuandmed).
            sales_mtime = datetime.fromtimestamp(sales_backup.stat().st_mtime).strftime("%Y-%m-%d %H:%M:%S")
            cust_mtime = datetime.fromtimestamp(customers_backup.stat().st_mtime).strftime("%Y-%m-%d %H:%M:%S")
            
            df_sales = pd.read_csv(sales_backup)
            df_customers = pd.read_csv(customers_backup)
            used_fallback = True
            
            data_source_log = (
                f"FALLBACK (kohalikud CSV-failid: {sales_backup}, {customers_backup}) | "
                f"Failid loetud: {fallback_time} | Varufailide seis: sales={sales_mtime}, customers={cust_mtime}"
            )
            logging.warning(f"[ANDMEALLIKAS] Kasutati: {data_source_log} | Read: {len(df_sales)} müüki, {len(df_customers)} klienti.")
            
            warn_msg = f"Supabase oli maas ({fallback_time}). Kasutati varufaile seisuga {sales_mtime}."
            send_notification("ETL Fallback Kasutusel", warn_msg, is_error=False)
        else:
            fatal_msg = f"Supabase on maas ({fallback_time}) JA varufaile kaustas '{CACHE_DIR}' ei leitud! Töö katkestatakse."
            logging.error(fatal_msg)
            send_notification("ETL Kriitiline Viga", fatal_msg, is_error=True)
            raise RuntimeError(fatal_msg) from e

    # 2. TRANSFORM andmed
    def transform():
        clean = clean_data_advanced(df_sales)
        merged = merge_datasets(clean, df_customers)
        weekly, kpis = calculate_weekly_aggregates(merged), calculate_kpis(merged)
        if weekly.empty:
            raise ValueError("Nädalaste koondandmete arvutamine andis tühja tulemuse.")
        logging.info(f"Transform lõpetatud. KPI-d: {kpis}")
        return clean, weekly, kpis

    df_sales_clean, df_weekly, kpis = run_step("Etapp 2: Transform", "ETL Transform Hoiatus", transform)

    # 3. EXPORT failid
    csv_path = run_step(
        "Etapp 3: Export", "ETL Export Ebaõnnestus", lambda: export_results(df_weekly, output_dir, kpis)
    )
    logging.info(f"Export lõpetatud. Fail salvestatud: {csv_path}")

    # KOKKUVÕTE
    source_note = "Kasutati varufaile - Supabase oli maas" if used_fallback else "Supabase otseühendus"
    summary = (
        f"UrbanStyle.ltd ETL pipeline lõpetas edukalt!\n"
        f"- Andmeallikas: {source_note}\n"
        f"- Töödeldud müügiridu: {len(df_sales_clean)}\n"
        f"- Kogutulu: {kpis['total_revenue']} €\n"
        f"- Unikaalseid kliente: {kpis['unique_customers']}\n"
        f"- Keskmine tellimus: {kpis['avg_order_value']} €\n"
        f"- Väljundfail: {csv_path}"
    )
    print(f"\n{summary}\n")
    send_notification("UrbanStyle ETL Raport Valmis", summary)
    logging.info(f"Pipeline valmis | Lõppaeg: {datetime.now():%Y-%m-%d %H:%M:%S} | {data_source_log} | Töödeldud ridu: {len(df_sales_clean)}")

# Käivitab andmetöötlusprotsessi, müüdab selletäitmiseks kuluvat aega ja logib võimalikud vead. 
if __name__ == "__main__":
    t0 = time.time()
    try:
        run_pipeline()
    except Exception as err:
        logging.error(f"Pipeline katkestas töö vea tõttu: {err}")
    finally:
        logging.info(f"Kogu protsessi täitmise aeg: {round(time.time() - t0, 2)} sekundit.")