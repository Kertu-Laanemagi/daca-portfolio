-- Week 5 - Grupitöö Roll B Turunduse dashboard
============================================
-- Enamus koodi pärinev week 4 grupitöö roll D - turunduskanalite analüüs.  Täiendatud AI abil saamaks üks täiustatud tabel.
-- CTE-ga kanali efektiivsuse arvutamine. Lisatud window function kuust-kuusse kasvu leidmiseks.
-- Saadud andmed csv tabelina Power BI laetud ja edasine analüüs, visuaalide loomine.
============================================
WITH müügi_kanalid AS (
    SELECT 
        o.customer_id,
        o.total_price,
        o.sale_date,
        -- Grupeerimiseks vajalik kuu alguspunkt
        DATE_TRUNC('month', o.sale_date) AS kuu,
        -- Kliendi kõige esimene külastus üldse (kohordi alguspunkt)
        (
            SELECT MIN(w2.visit_date)
            FROM web_logs w2
            WHERE w2.customer_id = o.customer_id
        ) AS esimese_logi_kuupaev,
        -- Atributsioon: viimane puude enne konkreetset ostu
        (
            SELECT 
                CASE 
                    WHEN LOWER(TRIM(w.source)) IN ('google', 'google_ads') THEN 'google_ads'
                    WHEN LOWER(TRIM(w.source)) IN ('google organic', 'google_organic') THEN 'google_organic'
                    WHEN LOWER(TRIM(w.source)) IN ('fb', 'facebook', 'facebook ads', 'facebook_ads', 'fb_ads') THEN 'facebook'
                    WHEN LOWER(TRIM(w.source)) IN ('ig', 'instagram', 'instagram_ads', 'ig_ads') THEN 'instagram'
                    WHEN LOWER(TRIM(w.source)) = 'email_campaign' THEN 'email'
                    ELSE LOWER(TRIM(w.source))
                END
            FROM web_logs w
            WHERE w.customer_id = o.customer_id 
              AND w.source IS NOT NULL
              AND w.visit_date <= o.sale_date
            ORDER BY w.visit_date DESC
            LIMIT 1
        ) AS kanal_puhas
    FROM sales o
),

kanali_kuine_myyk AS (
    SELECT 
        COALESCE(kanal_puhas, 'veebilogis puudub / seostamata') AS turunduskanal,
        kuu,
        SUM(total_price) AS kogukaive,
        COUNT(*) AS tellimuste_arv,
        COUNT(CASE WHEN sale_date <= esimese_logi_kuupaev + INTERVAL '30 days' THEN 1 END) AS tellimused_30_paeva_jooksul
    FROM müügi_kanalid
    GROUP BY COALESCE(kanal_puhas, 'veebilogis puudub / seostamata'), kuu
),
kanali_kuised_kliendid AS (
    SELECT 
        COALESCE(kanal_puhas, 'veebilogis puudub / seostamata') AS turunduskanal,
        DATE_TRUNC('month', sale_date) AS kuu,
        COUNT(DISTINCT customer_id) AS unikaalsed_kliendid
    FROM müügi_kanalid
    GROUP BY COALESCE(kanal_puhas, 'veebilogis puudub / seostamata'), DATE_TRUNC('month', sale_date)
),
kuine_koond AS (
    SELECT 
        m.turunduskanal,
        m.kuu,
        m.kogukaive,
        k.unikaalsed_kliendid,
        m.tellimuste_arv,
        ROUND((m.kogukaive / k.unikaalsed_kliendid)::numeric, 2) AS myyk_per_klient,
        ROUND((m.tellimuste_arv::numeric / k.unikaalsed_kliendid), 2) AS tellimuste_tihedus,
        ROUND((m.kogukaive / m.tellimuste_arv)::numeric, 2) AS keskmine_ostukorv,
        ROUND((m.tellimused_30_paeva_jooksul::numeric / k.unikaalsed_kliendid), 2) AS kohordi_tihedus_30_paeva
    FROM kanali_kuine_myyk m
    JOIN kanali_kuised_kliendid k ON m.turunduskanal = k.turunduskanal AND m.kuu = k.kuu
    WHERE m.tellimuste_arv > 5
)
SELECT 
    turunduskanal,
    kuu,
    kogukaive,
    unikaalsed_kliendid,
    tellimuste_arv,
    myyk_per_klient,
    tellimuste_tihedus,
    keskmine_ostukorv,
    kohordi_tihedus_30_paeva,
    -- Aknafunktsioon eelmise kuu käibe leidmiseks (PARTITION BY puhastatud kanali järgi)
    LAG(kogukaive) OVER (
        PARTITION BY turunduskanal
        ORDER BY kuu
    ) AS eelmise_kuu_käive,
    ROUND((
        (kogukaive - LAG(kogukaive) OVER (PARTITION BY turunduskanal ORDER BY kuu))::numeric 
        / LAG(kogukaive) OVER (PARTITION BY turunduskanal ORDER BY kuu)::numeric
    ) * 100, 2) AS kuine_kasv_protsent
FROM kuine_koond
ORDER BY kuu ASC, kogukaive DESC;

-- kontroll, kas müügisumma on õige leitud andmetes.
select sum(total_price) from sales
