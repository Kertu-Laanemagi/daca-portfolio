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
