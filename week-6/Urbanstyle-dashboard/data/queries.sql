-- Päringud 1-4 nädalast
==============================================
-- ============================================
-- Päring: Iseseisev töö nädal 1
-- Autor: Kertu Läänemägi
-- Kuupäev: 2026-09-30
-- Eesmärk: Vastata Toomase esitatud küsimustele 
-- ============================================

-- Mitu veergu on tabelis ?  Vastus: 12
select * from sales limit 5;

-- Milline on suurim summa 10 rea sees? Vastus: 629,96
Select sale_id, customer_id, total_price, sale_date from sales limit 10;

-- Milline on kõige suurem müük kogu tabelis?  Vastus: 2170,40
select sale_id, total_price as summa from sales order by total_price desc limit 5;

-- Leia kõige väiksemad müügid? Vastus: -1405,32 aga see  on kreeditarve
select sale_id, total_price as summa from sales order by total_price asc limit 5;

-- Leia kõige väiksemad müügid, mis ei ole kreeditarved? Vastus: 15,09
select sale_id, total_price as summa from sales where total_price> 0 order by total_price asc limit 5;

-- Toomasele tellimuste loetelu
select customer_id as kliendi_id, sale_date as kuupäev,total_price as summa from sales order by sale_date desc limit 20;

-- Suured tellimused? Vastus 2499 müüki on suuremad kui 500. 
select sale_id, customer_id, total_price
from sales
where total_price > 500
order by total_price desc limit 10;

-- Mitu müüki oli 2024 aasta esimeses kvartalis?  Tabelis Date formaat vale ja seetõttu kasutatud päringus Where cast (sale_date as Date) lausendit. Vastus: 1604
SELECT sale_id, sale_date, total_price
FROM sales
WHERE cast (sale_date as date) BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY sale_date;

-- Mitu tellimust on ilma kliendi IDta?  Vastus 1487 rida on ilma kliendi IDta. 
SELECT sale_id, customer_id, total_price
FROM sales
WHERE customer_id IS NULL;

-- Toomas tahab näha tellimusi, mis vastavad: summa üle 200 ja müügikuupäev 2024 aasta? Vastus: 2024 aastal tehti 4233 müügitegingut, mis ületasid 200 summa. 
SELECT sale_id, sale_date, total_price
FROM sales
WHERE cast (sale_date as date) BETWEEN '2024-01-01' AND '2024-12-31' and total_price > 200
ORDER BY sale_date;

-- Lisa juurde omal valikul müügikanal?  Vastus: Poest tehti 2024 aastal 2652 müügitehingut üle 200. 
SELECT sale_id, sale_date, total_price, channel
FROM sales
WHERE cast (sale_date as date) BETWEEN '2024-01-01' AND '2024-12-31' and total_price > 200 and channel = 'pood'
ORDER BY sale_date;

-- Kui palju on kahtlaseid ridu?  Vastus: Sales tabelis on 1766 rida kus summa on kas 0/ negatiivne või on puudu kliendinumber.
select sale_id, customer_id, total_price, sale_date
from sales
where total_price <= 0 OR customer_id IS NULL
order by total_price asc;

-- Mitu rida on  tabelis kokku? Vastus: Tabelis on 15234 rida.
select count (*) as ridade_arv from sales;

-- Mitu rida omab customer_id väärtust? Vastus: 13747
select count (customer_id) as klientidega_tellimused from sales;

-- Mitu klienti on teinud tellimusi?  Vastus: 2558 klienti
select count (distinct customer_id) as unikaalaseid_kliente from sales;

-- Mitu null on customer_id ridades? Vastus: 1487 real on puudu kliendi ID
SELECT
    COUNT(*) AS kokku,
    COUNT(customer_id) AS klientidega,
    COUNT(*) - COUNT(customer_id) AS puuduvaid
FROM sales;

-- Üldine tabel klientid
SELECT
    COUNT(*) AS ridade_arv,
    COUNT(customer_id) AS klientidega,
    COUNT(*) - COUNT(customer_id) AS puudub_klient,
    COUNT(DISTINCT customer_id) AS unikaalseid_kliente
FROM sales;
| ridade_arv | klientidega | puudub_klient | unikaalseid_kliente |
| ---------- | ----------- | ------------- | ------------------- |
| 15234      | 13747       | 1487          | 2558                |

-- Unikaalsed müügikanalid? Vastus: Firmal on 2 müügikanalit: füüsiline pood ja online
select distinct channel from sales order by channel;

-- Unikaalsed staatused? Vastus: veateade, sest sales tabelis ei ole veergu nimega status. Parandatud sql koodi loyality_tier, sees on customer tabelis olemas
select distinct status from sales order by status;
select distinct loyalty_tier from customers order by loyalty_tier; -- Vastus: klientidel on 3 lojaalsustaset

-- Leia Toomasele duplikaadid.
select count (*) as kokku from sales; -- 15234
select count (distinct sale_id) as unikaalseid from sales;  -- Vastus 10118
select 15234-10118 as vahe; -- Vastus; duplikaate on 5116 rida

-- Leia puuduvate emailidega kliendid
select
    count (*) as kokku,
    count (distinct email) as unikaalseid_emaile,
    count (*) - count (distinct email) as duplikaatseid
from customers;

| kokku | unikaalseid_emaile | duplikaatseid |
| ----- | ------------------ | ------------- |
| 3150  | 2640               | 510           |

-- Leia tootetabelist vajalikud andmed
select
    count (*) as toodete_arv,
    count (distinct category) as unikalsed_kategooriad,
    count (*) - count (retail_price) as puuduvad_hinnad
from products;

| toodete_arv | unikalsed_kategooriad | puuduvad_hinnad |
| ----------- | --------------------- | --------------- |
| 362         | 5                     | 0               |



-- Harjutus 1A: leia kõik duplikaatsed sale_id väärtused sales tabelis
SELECT
    sale_id,
    COUNT(*) AS koopiate_arv
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC
LIMIT 10;
-- Tulemus: suurim koopiate arv on 6.
-- sale_id 4256 ja sale_id 2706 esinevad mõlemad 6 korda.

-- Harjutus 1A: mitu erinevat sale_id-d esineb rohkem kui korra?
SELECT COUNT(*) AS duplikaatseid_sale_id
FROM (
    SELECT sale_id
    FROM sales
    GROUP BY sale_id
    HAVING COUNT(*) > 1
) AS duplikaadid;
-- Vastused:
-- 1. 4013 Sales ID esineb rohkem kui korra
-- 2. Kõige enim on duplikaate sales_id 4256 ja 2706
-- 3. Mõlemal 6 koopiat

-- Harjutus 1A: duplikaatide mõju müüginumbritele
SELECT
    COUNT(*) AS ridu_kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate,
    SUM(total_price) AS summa_duplikaatidega,
    (SELECT SUM(total_price) FROM (
        SELECT DISTINCT ON (sale_id) total_price
        FROM sales
        ORDER BY sale_id, sale_date
    ) unikaalsed) AS summa_ilma_duplikaatideta
FROM sales;
-- Ridu kokku: 15 234
-- Unikaalseid sale_id väärtusi: 10 118
-- Duplikaate: 5 116
-- Müügisumma koos duplikaatidega: 4 374 231,27 €
-- Müügisumma ilma duplikaatideta: 2 896 951,38 €
-- Duplikaatide rahaline mõju: 1 477 279,89 €

-- Harjutus 1B: leia sama e-mailiga duplikaatsed kliendikirjed
SELECT *
FROM (
    SELECT
        customer_id,
        first_name,
        last_name,
        email,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY customer_id
        ) AS rn
    FROM customers
    WHERE email IS NOT NULL
) AS kliendid
WHERE rn > 1
ORDER BY email, rn;

-- Supabase kuvas 128 duplikaatset kliendikirjet.
-- Kuvatud duplikaatidel on rn = 2, mis tähendab, et sama e-mailiga on olemas veel üks kirje.
-- Täpset duplikaatsete e-mailide koguarvu kontrollime järgmise COUNT päringuga.

-- Harjutus 1B: mitu erinevat e-maili esineb rohkem kui ühe korra?
SELECT COUNT(*) AS duplikaatseid_email_aadresse
FROM (
    SELECT email
    FROM customers
    WHERE email IS NOT NULL
    GROUP BY email
    HAVING COUNT(*) > 1
) AS duplikaadid;
-- Customers tabelis esineb 128 erinevat e-maili aadressi rohkem kui üks kord.

-- Harjutus 1B: kontrolli, kas sama e-mailiga klientidel on erinevad nimed
SELECT
    email,
    COUNT(*) AS kirjete_arv,
    COUNT(DISTINCT CONCAT(first_name, ' ', last_name)) AS erinevaid_nimesid
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1
   AND COUNT(DISTINCT CONCAT(first_name, ' ', last_name)) > 1
ORDER BY erinevaid_nimesid DESC, email;
-- Jah, sama e-mailiga kliendikirjetel esineb erinevaid nimesid
-- Näiteks maris.paas@mail.ee esineb 3 kirjes ja nende taga on 3 erinevat nime.
-- See viitab võimalikule andmekvaliteedi probleemile.
-- Võimalik põhjus: sama e-mail on sisestatud mitme kliendikirje juurde
-- või kliendiandmed on süsteemi korduvalt/ebakorrektselt sisestatud.

-- Harjutus 1C: products tabeli duplikaatide audit
-- Duplikaadi aluseks valin product_id, sest toote ID peaks identifitseerima ühe toote.

SELECT
    product_id,
    COUNT(*) AS koopiate_arv
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Products tabelis ei leitud ühtegi korduvat product_id väärtust.
-- Duplikaatide arv: 0.
-- product_id valiti kontrolli aluseks, sest see peaks identifitseerima ühe konkreetse toote.

-- Harjutus 1C: products tabeli duplikaatide audit - parandatud versioon
SELECT product_name, COUNT(*) AS koopiate_arv
FROM products
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Products tabelis leitud korduvat product_name väärtust.
-- Duplikaatide arv: 12.
-- product_name valiti kontrolli aluseks, sest see peaks identifitseerima kui on mitu sama nimega toodet

-- Harjutus 2A: NULL-ide ülevaade customers tabelis
SELECT
    COUNT(*) AS kliente_kokku,
    COUNT(first_name) AS eesnimi_olemas,
    COUNT(*) - COUNT(first_name) AS eesnimi_puudub,
    COUNT(email) AS email_olemas,
    COUNT(*) - COUNT(email) AS email_puudub,
    COUNT(phone) AS telefon_olemas,
    COUNT(*) - COUNT(phone) AS telefon_puudub
FROM customers;

-- Kliente kokku: 3150
-- Eesnimi puudub: 0
-- E-mail puudub: 380
-- Telefon puudub: 0

-- Harjutus 2A: kliendid, kellel puudub nimi VÕI e-mail
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    city
FROM customers
WHERE first_name IS NULL
   OR last_name IS NULL
   OR email IS NULL
ORDER BY customer_id
LIMIT 15;

-- Kuvatud puudulike andmetega klientidel puudub e-mail.
-- Kliendid on erinevatest linnadest (nt Pärnu, Tartu, Haapsalu, Paide ja Tallinn).
-- Esimeste kirjete põhjal ei ole puuduvad andmed seotud ainult ühe linnaga.

-- Harjutus 2B: COALESCE puuduvate kliendiandmete kuvamiseks
SELECT
    customer_id,
    COALESCE(first_name, 'Tundmatu') AS eesnimi,
    COALESCE(last_name, '') AS perekonnanimi,
    COALESCE(email, 'E-mail puudub') AS email,
    COALESCE(phone, 'Telefon puudub') AS telefon
FROM customers
WHERE first_name IS NULL
   OR last_name IS NULL
   OR email IS NULL
   OR phone IS NULL;

-- COALESCE kuvab puuduvate väärtuste asemel soovitud asendusväärtuse.
-- Näiteks NULL e-maili asemel kuvatakse väärtus "E-mail puudub".
-- COALESCE ei muutnud customers tabeli algandmeid, vaid muutis ainult SELECT päringu tulemustes kuvatavat väärtust.

-- Harjutus 2B: mitu klienti vajab COALESCE asendusväärtust?
SELECT COUNT(*) AS coalesce_vajavaid_kliente
FROM customers
WHERE first_name IS NULL
   OR last_name IS NULL
   OR email IS NULL
   OR phone IS NULL;

-- COALESCE asendust vajab 380 klienti.
-- Selles andmestikus on puuduvad andmed e-mail veerus.

-- Harjutus 2C: NULL-ide mõju arvutustele
SELECT
    COUNT(*) AS ridu,
    COUNT(total_price) AS summa_olemas,
    COUNT(*) - COUNT(total_price) AS summa_puudub,
    SUM(total_price) AS kogusumma,
    AVG(total_price) AS keskmine
FROM sales;

-- Ridu kokku: 15 234
-- total_price väärtus olemas: 15 234
-- total_price NULL väärtusi: 0
-- Kogusumma: 4 374 231,27 €
-- Keskmine müügisumma: 287,14 €
-- Selles andmestikus ei mõjuta NULL-id total_price arvutusi, sest NULL väärtusi ei ole.
-- Oluline: SUM() ja AVG() ignoreerivad NULL väärtusi automaatselt.

-- Harjutus 3A: kuupäevade formateerimine UrbanStyle'i andmetes
SELECT
    sale_id,
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_kuupaev,
    TO_CHAR(sale_date, 'Day') AS nadalapaev,
    TO_CHAR(sale_date, 'YYYY-"Q"Q') AS kvartal,
    EXTRACT(DOW FROM sale_date) AS paev_nr
FROM sales
ORDER BY sale_date DESC
LIMIT 10;
-- Tulemus:
-- sale_date kuvatakse vaikimisi formaadis YYYY-MM-DD HH:MI:SS.
-- Kõige viimane tellimus oli 28.06.2026, pühapäeval (Sunday).
-- Kõige viimane tellimus oli 2026. aasta II kvartalis (2026-Q2).

-- Harjutus 3A: linnade ühtlustamise diagnostika
SELECT
    city AS originaal,
    TRIM(city) AS trimitud,
    INITCAP(TRIM(city)) AS puhastatud,
    COUNT(*) AS kliente
FROM customers
GROUP BY city
ORDER BY city;

-- Linnade originaal-, trimitud ja puhastatud kirjaviisid on võrdluseks kuvatud.
-- Kuvatud tulemustes on nimed juba ühtlustatud kirjapildiga.
-- TRIM() ja INITCAP() ei ole muutnud selles päringus customers tabeli andmeid.

-- Harjutus 3B: linnade puhastatud statistika
SELECT
    INITCAP(TRIM(city)) AS puhastatud_linn,
    COUNT(*) AS kliente_kokku,
    COUNT(DISTINCT city) AS erinevaid_algseid_kirjaviise
FROM customers
WHERE city IS NOT NULL
GROUP BY INITCAP(TRIM(city))
ORDER BY kliente_kokku DESC;
-- Unikaalseid linnu: 12.
-- Jah, mitmel linnal on rohkem kui üks kirjaviis.
-- Näiteks Tallinnal, Tartul ja Pärnul on 5 erinevat algset kirjaviisi.
-- GROUP BY puhastatud linnanime järgi annab õigema tulemuse,
-- Päring ei ole muutnud customers tabeli andmeid.

-- Harjutus 3C: products tabeli hindade kontroll
SELECT
    product_id,
    product_name,
    retail_price,
    CASE
        WHEN retail_price IS NULL THEN 'NULL'
        WHEN retail_price = 0 THEN 'NULL (0 = puudub?)'
        WHEN retail_price < 0 THEN 'NEGATIIVNE!'
        ELSE 'OK'
    END AS hinna_staatus
FROM products
WHERE retail_price IS NULL OR retail_price <= 0
ORDER BY retail_price;

-- Probleemseid hindu ei leitud.
-- Products tabelis ei ole NULL-, 0- ega negatiivse retail_price väärtusega tooteid.
-- Päring tagastas 0 rida.

-- Harjutus 3C: kontrolli probleemsete hindade arvu
SELECT
    COUNT(*) AS tooteid_kokku,
    COUNT(*) FILTER (WHERE retail_price IS NULL) AS null_hinnaga,
    COUNT(*) FILTER (WHERE retail_price = 0) AS null_hinnaga_0,
    COUNT(*) FILTER (WHERE retail_price < 0) AS negatiivse_hinnaga
FROM products;

-- Products tabelis on 362 toodet.
-- NULL hinnaga tooteid: 0
-- 0-hinnaga tooteid: 0
-- Negatiivse hinnaga tooteid: 0
-- retail_price väärtused läbisid kontrolli ning CAST NUMERIC tüübiks õnnestus.
-- Selle kontrolli põhjal ei leitud products tabeli hindades probleeme.

-- TOOMASE PUHASTAMISRAPORT
-- Päring 1: duplikaatide ülevaade kõigis tabelites

SELECT
    'sales' AS tabel,
    COUNT(*) AS ridu_kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate
FROM sales

UNION ALL

SELECT
    'customers',
    COUNT(*),
    COUNT(DISTINCT email),
    COUNT(*) - COUNT(DISTINCT email)
        - COUNT(*) FILTER (WHERE email IS NULL)
FROM customers

UNION ALL

SELECT
    'products',
    COUNT(*),
    COUNT(DISTINCT product_name),
    COUNT(*) - COUNT(DISTINCT product_name)
FROM products;

-- sales tabelis: 5 116 duplikaati.
-- customers tabelis: 130 duplikaati -NULL e-mailid on duplikaatide arvestusest välja jäetud.
-- products tabelis: 12 duplikaati.
-- Kõige rohkem duplikaate leiti sales tabelist: 5 116.
-- Toomase jaoks: suurim duplikaatide probleem on sales tabelis.


-- TOOMASE PUHASTAMISRAPORT
-- Päring 2: NULL väärtuste raport

SELECT
    'sales' AS tabel,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS puuduv_customer_id,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS puuduv_total_price
FROM sales

UNION ALL

SELECT
    'customers',
    COUNT(*) FILTER (WHERE email IS NULL),
    COUNT(*) FILTER (WHERE first_name IS NULL)
FROM customers

UNION ALL

SELECT
    'products',
    COUNT(*) FILTER (WHERE retail_price IS NULL),
    COUNT(*) FILTER (WHERE product_name IS NULL)
FROM products;

-- sales: 1487 kirjel puudub customer_id; total_price puudub 0 kirjel.
-- customers: 380 kirjel puudub email; first_name puudub 0 kirjel.
-- products: retail_price puudub 0 kirjel; product_name puudub 0 kirjel.
-- Toomase jaoks: kõige rohkem puuduvaid väärtusi on sales tabelis,
-- kus 1487 kirjel puudub customer_id.


-- TOOMASE PUHASTAMISRAPORT
-- Päring 3: linnanimede formaatide diagnostika

SELECT
    city AS originaal,
    INITCAP(TRIM(city)) AS puhastatud
FROM customers
WHERE city IS NOT NULL
GROUP BY city
ORDER BY INITCAP(TRIM(city)), city;

-- Päring 3: mitu linnanime kirjaviisi vajab ühtlustamist?
SELECT COUNT(DISTINCT city) AS ebajarjekindlaid_kirjaviise
FROM customers
WHERE city IS NOT NULL
  AND city <> INITCAP(TRIM(city));

-- Customers tabelis on kokku 54 erinevat algset linnanime kirjaviisi.
-- Pärast puhastamist koonduvad need 12 ühtseks linnanimeks.
-- 42 algset linnanime kirjaviisi erinevad puhastatud kujust ja vajavad ühtlustamist.
-- Toomase jaoks: leidsime 42 ebajärjekindlat linnanimede kirjaviisi,
-- mis tuleb ühtlustada.

================================================
--WEEK 3 - JOIN ISESEISEV TÖÖ
================================================
-- INNER JOIN harjutused 
--  1A INNER JOIN: kliendid koos nende müükidega
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.total_price DESC
LIMIT 20;
-- Mitu rida tulemus näitab? 20 rida
-- Milline klient on kõige suurema tellimusega? Madis Roots 2 170,40 €
-- Millisest linnast on enim kliente TOP 20-s? Tallinn
-- Proovi nüüd eemaldada LIMIT 20. Mitu rida kokku tuleb? 9130

-- 1B
-- Ühenda Sales ja Product tabelid, et näha toote nimi, kategooria, müüdud kogus ja ühikuhind, sorteeri koguse järgi kahanevalt, limit 15.
SELECT 
    p.product_name,
    p.category,
    s.quantity,
    s.unit_price
FROM sales s
INNER JOIN products p on p.product_id=s.sale_id
ORDER BY s.quantity DESC
LIMIT 15;
-- Milline toode on kõige rohkem müüdud? Klassikaline nahkne kindad
-- Kas kalleim toode on ka enim müüdud? 346,70 € maksev soe meriino villane topik
-- Mida see ütleb UrbanStyle'i klientide eelistuste kohta? ____Neile meeldivad moodsad ja trendikad asjad.

--1C
-- Millised kliendid tellisid viimase kuu jooksul?
SELECT
    c.first_name,
    c.last_name,
    s.sale_date,
    s.total_price,
    c.city
FROM sales s
INNER JOIN customers c ON c.customer_id=s.sale_id
Order by s.sale_date desc
LIMIT 20;
| first_name | last_name | sale_date           | total_price | city       |
| ---------- | --------- | ------------------- | ----------- | ---------- |
| Aili       | Lass      | 2026-06-28 00:00:00 | 253.23      | Tartu      |
| Siim       | Pihl      | 2026-06-27 00:00:00 | 583.44      | Rakvere    |
| Ülle       | Org       | 2026-06-15 00:00:00 | -128.44     | Narva      |
| Kadri      | Kõiv      | 2026-06-09 00:00:00 | 280.13      | Tallinn    |
| Erkki      | Aas       | 2026-04-02 00:00:00 | 98.68       | Narva      |
| Liis       | Puusepp   | 2026-01-01 00:00:00 | 163.53      | Tartu      |
| Triin      | Nõmm      | 2025-12-28 00:00:00 | 269.85      | Rakvere    |
| Kristjan   | Lõhmus    | 2025-12-27 00:00:00 | 338.43      | Jõhvi      |
| Erkki      | Mitt      | 2025-12-20 00:00:00 | 301.97      | Tartu      |
| Katrin     | Rebane    | 2025-12-12 00:00:00 | 65.00       | Tallinn    |
| Kristi     | Lill      | 2025-12-09 00:00:00 | 82.15       | Narva      |
| Annika     | Lepp      | 2025-12-09 00:00:00 | 100.57      | Tallinn    |
| Tiit       | Luik      | 2024-03-31 00:00:00 | 462.26      | Viljandi   |
| Pille      | Kivi      | 2024-03-31 00:00:00 | 296.40      | Valga      |
| sirje      | Kuusk     | 2024-03-31 00:00:00 | 302.90      | Valga      |
| merike     | Mets      | 2024-03-31 00:00:00 | 50.77       | Haapsalu   |
| riina      | Lõhmus    | 2024-03-31 00:00:00 | 78.09       | Tallinn    |
| Laura      | Kull      | 2024-03-30 00:00:00 | 138.13      | Tallinn    |
| Kati       | Lõoke     | 2024-03-30 00:00:00 | 373.54      | Kuressaare |
| anna       | Rosin     | 2024-03-30 00:00:00 | 245.59      | Kuressaare |

-- Mis oli kõige üllatavam INNER JOIN-i juures? Inner Join on küllaldki lihtne kasutada
-- Kuidas see erineb VLOOKUP-ist, mida oled Excelis kasutanud? vlookup otsiv vastused ühe lahtri kaupa, siin saab kasutada kogu tabelit kiiresti
-- Mida tahaksid sessioonis 1 mentorilt küsida? 

============================================
-- LEFT JOIN
============================================
-- Näide Urbanstyle kohta
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.total_price
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
ORDER BY s.total_price DESC NULLS LAST;

-- Kliendid, kes pole KUNAGI ostnud
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;
-- Leitud 599 registreeritud klienti kes ei ole sooritanud ühtegi ostu. 
-- Ma tahan näha ainult kliente, kes ON ostnud	INNER JOIN
-- Ma tahan näha KÕIKI kliente (ka neid, kes pole ostnud)	LEFT JOIN
-- Ma tahan leida kliente, kes POLE kunagi ostnud	LEFT JOIN + WHERE IS NULL
-- Ma tahan leida tooteid, mida POLE kunagi müüdud	LEFT JOIN + WHERE IS NULL

-- 1C leia kliendid, kes pole kunagi ostnud:
-- Kadunud kliendid: LEFT JOIN + WHERE IS NULL
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,-- loob ühe nime veeru kus pk ja eesnimi on koos
    c.email,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.registration_date DESC;
-- Mitu "kadunud" klienti leidsid? 599 kadunud klienti
-- Millisest linnast on enim kadunud kliente? Tallinn
-- Millal registreerus kõige vanem kadunud klient? 02-01-2020

-- Võrdluseks: INNER JOIN (ainult aktiivsed kliendid)
SELECT COUNT(DISTINCT c.customer_id) AS aktiivseid_kliente
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id;
-- Kui palju aktiivseid kliente on? 2551 aktiivset klienti
-- Arvuta: kadunud + aktiivsed = 3150 (kas see vastab kõigi klientide arvule?) ( 2551+599)

-- 2B Tooted ilma müügita
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.retail_price
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;
-- Mitu müümata toodet leidsid? 12 toodet,m ida ei ole kordagi müüdud
-- Millises kategoorias on enim müümata tooteid? aksessuaarid
-- Mis võiks olla põhjus, miks neid ei osteta? need on duplikaadid

--2C Kadunud kliendid, Kirjuta päring, mis grupeerib kadunud kliendid linnade kaupa ja näitab, mitu kadunud klienti on igas linnas.
SELECT c.city, 
       COUNT(DISTINCT c.customer_id) AS kadunud_kliendid
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL
GROUP BY c.city;
| city       | kadunud_kliendid |
| ---------- | ---------------- |
| Haapsalu   | 17               |
| Jõhvi      | 12               |
| Kuressaare | 18               |
| Narva      | 32               |
| Paide      | 11               |
| Pärnu      | 70               |
| Rakvere    | 17               |
| Tallinn    | 231              |
| Tartu      | 133              |
| Valga      | 25               |
| Viljandi   | 18               |
| Võru       | 15               |

-- Mis oli kõige üllatavam LEFT JOIN-i juures? 
-- Millal kasutaksid oma töös LEFT JOIN-i INNER JOIN-i asemel? 
-- Mida tahaksid sessioonis 1 mentorilt küsida? 

==================================================
-- RIGHT JOIN ja MITME TABELI ÜHENDAMINE
==================================================

-- Kliendi nimi + müügi kuupäev + toote nimi + müüdud kogus
--  Customer+sales+products
-- LEFT JOIN (kõik kliendid):
SELECT c.first_name, s.sale_id
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id;

-- RIGHT JOIN (sama tulemus, aga tabelid vastupidi):
SELECT c.first_name, s.sale_id
FROM sales s
RIGHT JOIN customers c ON s.customer_id = c.customer_id;

-- Mitme tabeli ühendamine
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city,
    s.sale_date,
    s.total_price,
    p.product_name,
    p.category,
    s.quantity,
    s.unit_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY s.total_price DESC
LIMIT 20;

-- Samm 1: sales ←JOIN→ customers
         (lisab kliendi nime ja linna)

-- Samm 2: tulemus ←JOIN→ products
         (lisab toote nime ja kategooria)

--Lõpptulemus: klient + müük + toode + kogus
-- Selge struktuur — igale JOIN-ile oma rida:
-- FROM sales s                                            -- Põhitabel
-- INNER JOIN customers c ON s.customer_id = c.customer_id -- + klient
-- INNER JOIN products p ON s.product_id = p.product_id    -- + tooteinfo

==============================================================================
-- 3A ühenda 3 tabelit, et näha klient + tellimus + toode:
-- 3 tabeli JOIN: kes ostis mida?
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city AS linn,
    s.sale_date AS müügi_kuupäev,
    p.product_name AS toode,
    p.category AS kategooria,
    s.quantity AS kogus,
    s.unit_price AS ühikuhind,
    s.total_price AS rea_summa
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY rea_summa DESC
LIMIT 20;
-- Milline toode on kõige suurema rea summaga? Õhuline sünteetiline sporditossud 5 tk 2170.40 €
-- Millisest linnast on see klient? Valga
-- Millises kategoorias on enim TOP 20 tooteid? Jalanõud


-- 3B Millised tootekategooriad müüvad igas linnas kõige rohkem?" 
SELECT 
    c.city, 
    p.category, 
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY c.city, p.category
ORDER BY kogumüük DESC;
-- Milline linn + kategooria kombinatsioon on kõige kasumlikum? Tallin ja jalanõud
-- Kas Tallinna ja Tartu klientide kategooriaeelistused erinevad? Tartu populaarseim on meeste riided
-- Mida Anna saaks selle info põhjal turunduses teha? Jah saaks, Anna saab hakata tegema piirkonna sihitud kampaaniaid. 


-- C Millised kliendid ostavad kõige kallimaid tooteid?
SELECT 
    c.first_name || ' ' || c.last_name AS klient, 
    MAX(p.retail_price) AS kalleim_ostetud_toode,
    p.product_name,
    c.city
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.first_name, c.last_name, p.product_name, c.city
ORDER BY kalleim_ostetud_toode DESC
LIMIT 10;
| klient       | kalleim_ostetud_toode | product_name                      | city       |
| ------------ | --------------------- | --------------------------------- | ---------- |
| Annika Paas  | 434.08                | Õhuline sünteetiline sporditossud | Pärnu      |
| Heino Mitt   | 434.08                | Õhuline sünteetiline sporditossud | Tallinn    |
| Hille Roots  | 434.08                | Õhuline sünteetiline sporditossud | Tallinn    |
| Tarmo Kuusik | 434.08                | Õhuline sünteetiline sporditossud | Valga      |
| Merike Vaher | 434.08                | Õhuline sünteetiline sporditossud | Tallinn    |
| Triin Valk   | 434.08                | Õhuline sünteetiline sporditossud | Rakvere    |
| Enn Kaalep   | 434.08                | Õhuline sünteetiline sporditossud | Tallinn    |
| Triin Kaalep | 434.08                | Õhuline sünteetiline sporditossud | Tallinn    |
| Heino Tammik | 434.08                | Õhuline sünteetiline sporditossud | Tallinn    |
| Anna Rosin   | 434.08                | Õhuline sünteetiline sporditossud | Kuressaare |


========================================================
-- Anna kampaaniaplaan
========================================================
--TOP 2 klienti koos tootekategooriatega
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city AS linn,
    p.category AS kategooria,
    SUM(s.total_price) AS kogumuuk
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, p.category
ORDER BY kogumuuk DESC
LIMIT 25;
| klient       | linn     | kategooria    | kogumuuk |
| ------------ | -------- | ------------- | -------- |
| Tiina Pärn   | Tartu    | jalanõusid    | 10940.40 |
| Priit Rand   | Pärnu    | naiste_riided | 8989.01  |
| Ago Lõoke    | Jõhvi    | jalanõusid    | 8803.37  |
| Kevin Org    | Tallinn  | jalanõusid    | 8309.52  |
| Anu Kuusik   | Tallinn  | jalanõusid    | 7865.61  |
| Laura Tammik | Pärnu    | meeste_riided | 7530.51  |
| Laura Tammik | Pärnu    | jalanõusid    | 7364.57  |
| Tiina Pärn   | Tartu    | naiste_riided | 6738.10  |
| Erkki Ilves  | Tartu    | jalanõusid    | 6712.25  |
| Riina Lill   | Pärnu    | meeste_riided | 6621.71  |
| Tiina Pärn   | Tartu    | meeste_riided | 6570.46  |
| Marika Sepp  | Tallinn  | naiste_riided | 5962.75  |
| Kevin Org    | Tallinn  | meeste_riided | 5909.99  |
| Terje Kukk   | Rakvere  | meeste_riided | 5794.51  |
| Erkki Ilves  | Tartu    | meeste_riided | 5790.14  |
| Pille Sepp   | Pärnu    | meeste_riided | 5623.35  |
| Erkki Ilves  | Tartu    | naiste_riided | 5585.61  |
| Kersti Lill  | Tallinn  | naiste_riided | 5570.67  |
| Annika Saar  | Viljandi | jalanõusid    | 5541.26  |
| Merike Vaher | Tallinn  | jalanõusid    | 5469.82  |
| Priit Rand   | Pärnu    | meeste_riided | 5426.48  |
| Ago Kull     | Pärnu    | meeste_riided | 5144.91  |
| Priit Rand   | Pärnu    | jalanõusid    | 5139.77  |
| Ago Kull     | Pärnu    | naiste_riided | 5108.85  |
| Kersti Lill  | Tallinn  | meeste_riided | 5078.04  |

-- Kadunud kliendid linnade kaupa
SELECT
    c.city AS linn,
    COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY c.city
ORDER BY kadunud_kliente DESC;

| linn       | kadunud_kliente |
| ---------- | --------------- |
| Tallinn    | 231             |
| Tartu      | 133             |
| Pärnu      | 70              |
| Narva      | 32              |
| Valga      | 25              |
| Kuressaare | 18              |
| Viljandi   | 18              |
| Haapsalu   | 17              |
| Rakvere    | 17              |
| Võru       | 15              |
| Jõhvi      | 12              |
| Paide      | 11              |


-- Müümata tooted kategooriate kaupa
SELECT
    p.category AS kategooria,
    COUNT(*) AS müümata_tooteid,
    ROUND(AVG(p.retail_price), 2) AS keskmine_hind
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
GROUP BY p.category
ORDER BY müümata_tooteid DESC;

| linn       | kadunud_kliente |
| ---------- | --------------- |
| Tallinn    | 231             |
| Tartu      | 133             |
| Pärnu      | 70              |
| Narva      | 32              |
| Valga      | 25              |
| Kuressaare | 18              |
| Viljandi   | 18              |
| Haapsalu   | 17              |
| Rakvere    | 17              |
| Võru       | 15              |
| Jõhvi      | 12              |
| Paide      | 11              |


==================================================
Iseseisvalt läbitud grupitöö osa B+C
==================================================

-- Roll B Left join + NULL
-- Customer, sales

-- LEFT JOIN: kõik kliendid, ka need kellel pole oste
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.registration_date,
    s.sale_id
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;
-- Kui sale_id on NULL, siis klient pole kunagi ostnud!
-- 599 registreeritud klienti ei ole sooritanud mitte ühtegi ostu

-- Kui palju on "Kadunud" kliente? 
SELECT COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;
-- Kadunud kliente on 599 inimest.

-- Kadunud kliendid linnade kaupa
SELECT
    c.city,
    COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY c.city
ORDER BY kadunud_kliente DESC;
-- Kõige rohkem on kadunud kliente Tallinnas - 231 ja kõige vähem Paides - 11. 


-- Millal kadunud kliendid registreerusid?
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.registration_date,
    c.city,
    c.loyalty_tier
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.registration_date DESC;
-- Küsimus mentorile - Kuidas on klientidel kes ei ole teinud ühtegi ostu lojaalsustase määratud. 
SELECT 
    c.loyalty_tier,
    COUNT(*) AS klientide_arv
FROM customers c 
LEFT JOIN sales s ON c.customer_id = s.customer_id 
WHERE s.sale_id IS NULL 
GROUP BY c.loyalty_tier
ORDER BY klientide_arv DESC;
| loyalty_tier | klientide_arv |
| ------------ | ------------- |
| null         | 236           |
| bronze       | 210           |
| silver       | 109           |
| gold         | 44            |

-- Kadunud klientide võrdlus aktiivsete klientidega?
SELECT
    CASE
        WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'
        ELSE 'Aktiivne (on ostnud)'
    END AS staatus,
    COUNT(DISTINCT c.customer_id) AS kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY
    CASE
        WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'
        ELSE 'Aktiivne (on ostnud)'
    END;
-- Tuleb ka teistest päringutest välja, et aktiivseid kliente 2551 ja kadunud kliente 599
| staatus               | kliente |
| --------------------- | ------- |
| Aktiivne (on ostnud)  | 2551    |
| Kadunud (pole ostnud) | 599     |

-- Lisa ajaline analüüs: grupeeri kadunud kliendid registreerimiskuu kaupa ja otsi mustreid:
SELECT
    DATE_TRUNC('month', c.registration_date) AS registreerimis_kuu,
    COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY DATE_TRUNC('month', c.registration_date)
ORDER BY registreerimis_kuu DESC;
-- Saadud kuuõäevade puhul on näha muster, et 2023 aasta juuli-augustist alates on olnud suurenenud kadunud klientide hulk iga kuu. Varasema 1-6 kliendi puhul hüppas "Kadunute" arv 9-14. 2024 mai-juuni alates 19-26 ning sep edasi 32-53 inimeseni kuus. 

========================================
Roll C products, sales, inventory

-- LEFT JOIN: kõik tooted, ka need mis pole müüdud
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    p.retail_price,
    s.sale_id
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;
-- Kui sale_id on NULL, siis toodet pole kunagi müüdud!

-- LEFT JOIN: kõik tooted, ka need mis pole müüdud lisatud product_id
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.retail_price,
    s.sale_id
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
-- Kui sale_id on NULL, siis toodet pole kunagi müüdud!
-- Need on duplikaat kirjed product tabelis.

-- Loe müümata tooted kokku:
SELECT COUNT(*) AS müümata_tooteid
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;
-- 12 müümata toodet.

-- Enimmüüdud tooted?
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    COUNT(s.sale_id) AS müüdud_kordi,
    SUM(s.total_price) AS kogumüük
FROM products p
INNER JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.subcategory
ORDER BY kogumüük DESC
LIMIT 10;
| product_name                               | category      | subcategory | müüdud_kordi | kogumüük |
| ------------------------------------------ | ------------- | ----------- | ------------ | -------- |
| Õhuline sünteetiline sporditossud          | jalanõusid    | tossud      | 35           | 27347.04 |
| Trendikas goretex oxfordid                 | jalanõusid    | kingad      | 32           | 23376.15 |
| Praktiline viskoosne jakk                  | naiste_riided | jakid       | 35           | 22188.80 |
| Praktiline džersii seelik                  | naiste_riided | seelikud    | 37           | 22039.98 |
| Boheemlaslik puuvillane tuulejope          | naiste_riided | jakid       | 30           | 21309.96 |
| Õhuline sünteetiline kõrge kontsaga kingad | jalanõusid    | kontsad     | 38           | 21295.56 |
| Praktiline kangast kõrge kontsaga kingad   | jalanõusid    | kontsad     | 37           | 21118.68 |
| Luksuslik villane pahkluu saapad           | jalanõusid    | botased     | 28           | 19704.87 |
| Praktiline merino villane parka            | meeste_riided | jakid       | 30           | 19620.45 |
| Õhuline linane jakk                        | naiste_riided | jakid       | 41           | 19393.29 |

-- Analüüsi kategooriate kaupa
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS tooteid,
    COUNT(s.sale_id) AS müüke,
    SUM(s.total_price) AS kogumüük
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY kogumüük DESC;

| category      | tooteid | müüke | kogumüük  |
| ------------- | ------- | ----- | --------- |
| jalanõusid    | 73      | 2031  | 774034.75 |
| meeste_riided | 82      | 2266  | 749798.72 |
| naiste_riided | 70      | 2022  | 686464.24 |
| aksessuaarid  | 67      | 1772  | 393035.82 |
| laste_riided  | 70      | 2027  | 305844.45 |

-- Millised tooted on laos?
SELECT
    p.product_name,
    p.category,
    i.location,
    i.quantity_available,
    i.reorder_point,
    CASE
        WHEN i.quantity_available <= i.reorder_point THEN 'TELLI JUURDE'
        ELSE 'OK'
    END AS staatus
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
ORDER BY i.quantity_available ASC;
-- Päringus 1412 rida mis on 4*362.  ¤ erinevat locationi - Poed Tallinnas, Tartus ja Pärnus ning ladu iga kaubaartili kohta eraldi.

-- Tootel laos mida ei ole kunagi müüdud. 
SELECT
    p.product_name,
    p.category,
    p.retail_price,
    i.quantity_available,
    (p.retail_price * i.quantity_available) AS kinni_olev_raha
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE s.sale_id IS NULL
  AND i.quantity_available > 0
ORDER BY kinni_olev_raha DESC;
-- Laos ei ole ühtegi tootet mida ei oleks müüdud. Seisvat raha laovarus kinni ei ole. 

===============================================
-- Roll D  - Sales table

-- Vaata, millised müügikanalid on olemas
SELECT DISTINCT channel FROM sales ORDER BY channel;
-- Märgi üles: mitu erinevat kanalit on?
-- kaks müügikanalit - pood ning online.

-- Milline kanal toob enim müüke?
SELECT
    s.channel AS müügikanal,
    COUNT(DISTINCT s.customer_id) AS kliente,
    COUNT(s.sale_id) AS oste,
    SUM(s.total_price) AS kogumüük
FROM sales s
GROUP BY s.channel
ORDER BY kogumüük DESC;
-- füüsiline pood toob rohkem tulu
| müügikanal | kliente | oste | kogumüük   |
| ---------- | ------- | ---- | ---------- |
| pood       | 2278    | 6656 | 1902430.30 |
| online     | 1706    | 3462 | 1006747.68 |

-- Millistest linnadest kliendid milliseid kanaleid kasutavad?
SELECT
    s.channel AS müügikanal,
    c.city AS linn,
    COUNT(DISTINCT c.customer_id) AS kliente,
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY s.channel, c.city
ORDER BY müügikanal, kogumüük DESC;

-- 3 tabeli JOIN: millised tooted müüvad millises kanalis?
SELECT
    s.channel AS müügikanal,
    p.category AS tootekategooria,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(s.sale_id) AS oste,
    SUM(s.total_price) AS kogumüük,
    ROUND(AVG(s.total_price), 2) AS keskmine_ost
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY s.channel, p.category
ORDER BY müügikanal, kogumüük DESC;

-- Leia kõige efektiivsem kanal (müük per klient):
SELECT
    s.channel AS müügikanal,
    COUNT(DISTINCT s.customer_id) AS kliente,
    SUM(s.total_price) AS kogumüük,
    ROUND(SUM(s.total_price) / COUNT(DISTINCT s.customer_id), 2) AS müük_per_klient
FROM sales s
GROUP BY s.channel
ORDER BY müük_per_klient DESC;

| müügikanal | kliente | kogumüük   | müük_per_klient |
| ---------- | ------- | ---------- | --------------- |
| pood       | 2278    | 1902430.30 | 835.13          |
| online     | 1706    | 1006747.68 | 590.12          |

-- Lisa kaupluste võrdlus: leia iga kaupluse müügikanalite jaotus:
SELECT
    s.store_location AS kauplus,
    s.channel AS müügikanal,
    COUNT(s.sale_id) AS oste,
    SUM(s.total_price) AS kogumüük,
    ROUND(SUM(s.total_price) / COUNT(s.sale_id), 2) AS keskmine_ost
FROM sales s
GROUP BY s.store_location, s.channel
ORDER BY kauplus, kogumüük DESC;
| kauplus | müügikanal | oste | kogumüük   | keskmine_ost |
| ------- | ---------- | ---- | ---------- | ------------ |
| Pärnu   | pood       | 1058 | 288744.04  | 272.91       |
| Tallinn | pood       | 3801 | 1092083.15 | 287.31       |
| Tartu   | pood       | 1797 | 521603.11  | 290.26       |
| null    | online     | 3462 | 1006747.68 | 290.80       |

================================================
--WEEK 4 - ISESEISEV TÖÖ - GROUP BY
================================================
-- GROUP by
-- 10 118 rida (iga tellimus eraldi) - iga rida eraldi tulemuses
SELECT sale_date, total_price
FROM sales;

-- -- 12 rida (iga kuu summa) - Liidab kokku iga kuu summa 
SELECT
    DATE_TRUNC('month', sale_date) AS kuu,
    SUM(total_price) AS kogukäive
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY kuu;
--  Tulemus: Iga kuu müügisummad on kokku võetud. Saadud 21 rida andmeid analtes 01.01.2024.


--1A. Müük kuude kaupa 2024. aastal. 
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS kuu,
    COUNT(*) AS tellimusi,
    SUM(total_price) AS käive,
    ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY kuu;
-- Tulemus: Saadud tabel, kus müügitulemused summeeritud kuude kaupa alates 01.01.2024.  Arvutatud on kokku iga kuu tellimuste arv, käive ja keskmine kuu müügisumma. 
-- Milline kuu oli kõige kasumlikum?
-- channelMilline kuu oli kõige madalam? 
-- Kas märkad trendi (kasv/langus)? 

-- 1B Koosta päring mis näitab müüke linnade kaupa summeeritult
SELECT 
    c.city,
    COUNT(s.sale_id) AS tellimusi,
    SUM(s.total_price) AS kogukäive,
    ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
FROM sales s
JOIN customers c on c.customer_id = s.customer_id
WHERE sale_date >= '2024-01-01'
GROUP BY c.city
ORDER BY kogukäive DESC
-- Millises linnas on kõige suurem kogukäive? Kõige suurem kogukäive on Tallinnas 571 649,39 €, tellimusi 2062.
-- Kas linn, kus on enim tellimusi, on ka kõige suurema käibega? Jah, Tallinnason kõige rohkem tellimusi ja suurim kogukäive.
-- Mis võiks seda erinevust seletada? Aga ei ole ju erinevust.

-- 1C Kuidas tasutakse Urbanstyle toodete eest. 
SELECT 
    payment_method AS makse_meetod,
    COUNT(*) AS kasutuskordi,
    SUM(total_price) AS kogukäive,
    ROUND(AVG(total_price), 2) AS keskmine_käive
FROM sales
GROUP BY payment_method
ORDER BY kogukäive DESC;

| makse_meetod | kasutuskordi | kogukäive | keskmine_käive |
| ------------ | ------------ | --------- | -------------- |
| järelmaks    | 3345         | 971983.50 | 290.58         |
| kaart        | 3372         | 968818.57 | 287.31         |
| sularaha     | 3401         | 968375.91 | 284.73         |

-- Mis oli kõige üllatavam GROUP BY juures? GROUP BY puhul on järjekord väga oluline ja et oleks õiged veerud pandud summeerima. 
-- Kuidas seostub see eelmise nädala JOIN-idega? Koos JION funktsiooniga saab otsida ning summeerida tabelite ridasid, mille abil tehajuhtimisotsuseid, KPI alusel. 

========================================================
-- 2. HAVING + AGGRE
========================================================
-- WHERE: ainult 2024. aasta tellimused 
-- WHERE filtreerib üksikuid ridu ENNE grupeerimist
SELECT
    DATE_TRUNC('month', sale_date) AS kuu,
    SUM(total_price) AS käive
FROM sales
WHERE sale_date >= '2024-01-01'  -- Filtreer ENNE grupeerimist
GROUP BY DATE_TRUNC('month', sale_date);

-- HAVING filtreerib gruppe PÄRAST grupeerimist. HAVING-us saab kasutada agregaatfunktsioone:
-- HAVING: ainult linnad, kus tellimusi > 10
SELECT
    c.city AS linn,
    COUNT(s.sale_id) AS tellimusi,
    SUM(s.total_price) AS kogukäive
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_date >= '2024-01-01'     -- WHERE: filtreer read kus on kindel filtri määrang
GROUP BY c.city
HAVING COUNT(s.sale_id) > 10          -- HAVING: filtreer gruppe, mis vastavad tingimusele
ORDER BY kogukäive DESC;

-- 2A. leia kliendid, kes on ostnud üle 500€: 
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    COUNT(s.sale_id) AS tellimuste_arv,
    SUM(s.total_price) AS kogukäive
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_price) > 500                  -- Mis muutub kui muuta 1000€
ORDER BY kogukäive DESC;
-- Mitu klienti ületas 500€ piiri? Kliente, keson kulutanud üle 500€ on 1722. 
-- Kes on TOP 3 klienti? TOP 3 klienti on: Tiina Pärn, Priit Rand ja Kevin Org. 
-- Kui muudad piiri 1000€ peale, mitu jääb? Kui piir seatud 1000 € peale siis on kliente 936 kes üleselle kulutanud. 

-- 2B. Liis varude audit. 
SELECT
    s.product_id,
    p.category,
    SUM(s.quantity) AS müüdud_kogus,
    COUNT(distinct p.product_id) AS tooted,
    ROUND(AVG(p.retail_price), 2) AS keskmine_müügihind
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category, s.product_id 
    HAVING SUM(s.quantity) > 50             
ORDER BY SUM(s.quantity) DESC;
-- Milline kategooria müüb kõige rohkem ühikuid? Jalanõud on kõige müüdavam kategooria. 
-- Milline on kõige kõrgema keskmise hinnaga kategooria?  Kõige kõrgem keskmine hind on samuti Jalanõudel 434 €, aga neid on ostetud 20 vähem kui kõige populaarsemat toodet. 
-- Kas kallim kategooria müüb ka rohkem? Miks / miks mitte? Ei müü alati, oleneb toote hinnastja kvaliteedist. 


2C. Näita ainult 2024. aasta Q1 tellimused (WHERE), grupeerituna kuu kaupa, kus käive on üle 5000€ (HAVING).
SELECT 
    EXTRACT(MONTH FROM sale_date) AS kuu,
    SUM(total_price) AS kogukäive,
    ROUND(AVG(total_price), 2) AS keskmine_käive
FROM sales
WHERE sale_date >= '2024-01-01' AND sale_date <= '2024-03-31'
GROUP BY EXTRACT(MONTH FROM sale_date)
HAVING SUM(total_price) > 5000
ORDER BY kuu ASC, kogukäive DESC;
| kuu | kogukäive | keskmine_käive |
| --- | --------- | -------------- |
| 1   | 85618.65  | 274.42         |
| 2   | 90181.83  | 270.01         |
| 3   | 109559.98 | 265.92         |
-- Mis oli kõige segasem koht WHERE vs HAVING juures? Meeles  pidada millal mida kasutada. 
-- Kuidas sa selgitaksid seda erinevust kellelegi, kes ei tea SQL-i? Where  on nagu  tavaline filter, kus saad ridu välja filtreerida ja Having on nagu pivot filter, kus saab välja jäta terveid gruppe. 

========================================================
-- 3. CTE + Window function
========================================================
-- CTE — sa annad igale vaheetapile nime ja kasutad seda järgmises sammus. Tulemus on loetavam ja debugitavam.
WITH kuu_myyk AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS käive
    FROM sales
    WHERE sale_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    kuu,
    käive,
    LAG(käive) OVER (ORDER BY kuu) AS eelmine_kuu,
    käive - LAG(käive) OVER (ORDER BY kuu) AS kasv
FROM kuu_myyk
ORDER BY kuu;

WITH kliendiinfo AS (
    SELECT customer_id, first_name || ' ' || last_name AS nimi, city
    FROM customers
),
kliendi_tellimused AS (
    SELECT
        customer_id,
        COUNT(sale_id) AS tellimusi,
        SUM(total_price) AS kogukäive
    FROM sales
    GROUP BY customer_id
)
SELECT
    k.nimi, k.city,
    kt.tellimusi, kt.kogukäive,
    CASE
        WHEN kt.kogukäive > 1000 THEN 'VIP'
        WHEN kt.kogukäive > 500 THEN 'Aktiivne'
        ELSE 'Tavaline'
    END AS segment
FROM kliendiinfo k
JOIN kliendi_tellimused kt ON k.customer_id = kt.customer_id
ORDER BY kt.kogukäive DESC;

-- 3A. CTE päring, mis arvutab kuu käive ja kasvu:
WITH kuu_myyk AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS käive
    FROM sales
    WHERE sale_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    kuu,
    käive,
    LAG(käive) OVER (ORDER BY kuu) AS eelmine_kuu,
    käive - LAG(käive) OVER (ORDER BY kuu) AS kasv,
    ROUND(
        100.0 * (käive - LAG(käive) OVER (ORDER BY kuu))
        / LAG(käive) OVER (ORDER BY kuu), 1
    ) AS kasv_protsent
FROM kuu_myyk
ORDER BY kuu;
-- Milline kuu näitas suurimat kasvu protsentides? Juuni 2026, kasvuprotsent 1715,4%
-- Milline kuu näitas langust? Jaanuar 2025 langusprotsent -95%
-- Miks on esimese kuu kasv NULL? Sellepärast, et seal ei ole millegist lahutada LAG(käivet)

-- 3B CTE-põhine päring, mis segmenteerib kliendid VIP / Aktiivne / Tavaline tasemetesse.
WITH kliendi_kokkuvote AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(s.sale_id) AS tellimuste_arv,
        SUM(s.total_price) AS kogukaive
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT
    nimi,
    city,
    tellimuste_arv,
    kogukaive,
    CASE
        WHEN kogukaive > 5000 THEN 'VIP'       -- Vali ise piir!
        WHEN kogukaive > 1000 THEN 'Aktiivne'  -- Vali ise piir!
        ELSE 'Tavaline'
    END AS segment
FROM kliendi_kokkuvote
ORDER BY kogukaive DESC;

-- 3C Kasuta ROW_NUMBER() funktsiooni, et leida iga kategooria TOP 3 toodet müüdud koguse järgi.
WITH toodete_müük AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(s.quantity) AS kogus,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(s.quantity) DESC) AS koht
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY p.category, p.product_name
)
SELECT 
    category,
    product_name,
    kogus,
    koht
FROM toodete_müük
WHERE koht <= 3
ORDER BY category, koht;

-- mis annab Kristile ülevaate TOP 5 linnast koos igakuise trendiga.
WITH linna_myyk AS (
    -- CTE 1: iga linna kogumüük
    SELECT
        c.city AS linn,
        COUNT(DISTINCT s.sale_id) AS tellimusi,
        SUM(s.total_price) AS kogukaive,
        ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    WHERE s.sale_date >= '2024-01-01'
    GROUP BY c.city
    HAVING COUNT(DISTINCT s.sale_id) > 5  -- Filtreeri välja väikesed linnad
),
linna_jarjestus AS (
    -- CTE 2: lisa järjestus
    SELECT
        linn,
        tellimusi,
        kogukaive,
        keskmine_tellimus,
        ROW_NUMBER() OVER (ORDER BY kogukaive DESC) AS koht
    FROM linna_myyk
)
SELECT *
FROM linna_jarjestus
WHERE koht <= 5
ORDER BY koht;
