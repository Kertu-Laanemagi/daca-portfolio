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
    COUNT(DISTINCT product_id),
    COUNT(*) - COUNT(DISTINCT product_id)
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
