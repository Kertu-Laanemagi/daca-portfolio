===========================================
-- Week 4 grupitöö: Agregeerimine
===========================================
-- 1. Kliendigruppide analüüs CTE, iga kliendi kogukulutus ja segmenteerimine.
-- a) Kogukulutus > 5000 VIP
-- b) Kogukulutus > 1000 Regular
-- c) Kogukulutus < 1000 Uus
WITH kliendi_kokkuvote AS (
  SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    c.city,
    COUNT(o.sale_id) AS tellimuste_arv,
    SUM(o.total_price) AS kogukäive
  FROM customers c
  JOIN sales o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT
  nimi,
  city,
  tellimuste_arv,
  kogukäive,
  CASE
    WHEN kogukäive > 5000 THEN 'VIP'       -- vali ise piir!
    WHEN kogukäive > 1000 THEN 'Regular'    -- vali ise piir!
    ELSE 'Uus'
  END AS segment
FROM kliendi_kokkuvote
ORDER BY kogukäive DESC;

-- 2. TOP 10 Klienti
select 
    c.customer_id,
    c.first_name || ' ' || c.last_name as kliendi_nimi, 
    COUNT(s.sale_id) as tellimuste_arv,
    sum(s.total_price) as kogukäive
from sales s
join customers c ON s.customer_id = c.customer_id
GROUP by c.customer_id
    Having COUNT(s.sale_id) > 2
Order by kogukäive desc
LIMIT 25;

-- VASTUSED:
| customer_id | kliendi_nimi | tellimuste_arv | kogukäive |
| ----------- | ------------ | -------------- | --------- |
| 3618        | Tiina Pärn   | 73             | 27668.02  |
| 3350        | Priit Rand   | 76             | 26286.10  |
| 2997        | Kevin Org    | 78             | 23467.13  |
| 2889        | Laura Tammik | 74             | 23385.82  |
| 3648        | Erkki Ilves  | 72             | 22942.42  |
| 3605        | Anu Kuusik   | 77             | 21626.10  |
| 4206        | Kersti Lill  | 71             | 21137.47  |
| 2221        | Riina Lill   | 67             | 20972.33  |
| 2154        | Annika Saar  | 66             | 20726.79  |
| 3722        | Ago Kull     | 64             | 20124.61  |


-- 3. Segmentide koondstatistika.  All pool on päring mis ühendab kõik punktid 3 ülesandes. 
-- a) Mitu klienti on igas segmendis (VIP, Regular, Uus)?    
-- b) Mis on iga segmendi keskmine käive?    

WITH kliendi_kokkuvote AS (
    SELECT 
        c.customer_id,
        CASE 
            WHEN SUM(s.total_price) > 5000 THEN 'VIP'
            WHEN SUM(s.total_price) > 1000 THEN 'Regular'
            ELSE 'Uus' 
        END AS segment,
        SUM(s.total_price) AS kogukaive
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id
)
SELECT 
    segment,
    COUNT(*) AS klientide_arv,                           -- a) Mitu klienti igas segmendis
    ROUND(AVG(kogukaive), 2) AS segmendi_keskmine_kaive  -- b) Segmendi keskmine käive
FROM kliendi_kokkuvote
GROUP BY segment
ORDER BY segmendi_keskmine_kaive DESC;
-- VASTUS:
| segment | klientide_arv | segmendi_keskmine_kaive |
| ------- | ------------- | ----------------------- |
| VIP     | 19            | 18 227.01               |
| Regular | 917           | 1 615.43                |
| Uus     | 1615          | 492.30                  |
===========================================================
-- 3. Segmentide koondstatistika
-- a) Mitu klienti on igas segmendis (VIP, Regular, Uus)?    
-- b) Mis on iga segmendi keskmine käive?    
-- c) Millistes linnades on kõige rohkem VIP-kliente?

WITH kliendi_kokkuvote AS (
    -- 1. Samm: Arvutame iga kliendi käibe, tellimused ja asukoha
    SELECT c.customer_id, c.city,
        SUM(o.total_price) AS kogukaive
    FROM customers c
    JOIN sales o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.city
),
segmenteeritud_kliendid AS (
    -- 2. Samm: Sildistame kliendid reeglite järgi segmentidesse
    SELECT customer_id, city, kogukaive,
        CASE 
            WHEN kogukaive > 5000 THEN 'VIP'
            WHEN kogukaive > 1000 THEN 'Regular'
            ELSE 'Uus' 
        END AS segment
    FROM kliendi_kokkuvote
),
linnade_vip_pingerida AS (
    -- 3. Samm: Loendame VIP-id linnade kaupa ja tekitame loetava teksti (nt "Tallinn (12)")
    SELECT city, COUNT(*) AS vip_arv,
        city || ' (' || COUNT(*) || ')' AS linna_info
    FROM segmenteeritud_kliendid
    WHERE segment = 'VIP'
    GROUP BY city
)
-- 4. Samm: Paneme punktid a, b ja c lõpptabelisse kokku
SELECT 
    s.segment,
    COUNT(*) AS klientide_arv,                           -- a) Mitu klienti on igas segmendis
    ROUND(AVG(s.kogukaive), 2) AS segmendi_keskmine_kaive, -- b) Mis on iga segmendi keskmine käive
    CASE 
        WHEN s.segment = 'VIP' THEN (
            SELECT STRING_AGG(linna_info, ', ' ORDER BY vip_arv DESC) 
            FROM linnade_vip_pingerida
        )
        ELSE '-' 
    END AS enim_vip_kliente_linnades
FROM segmenteeritud_kliendid s
GROUP BY s.segment
ORDER BY segmendi_keskmine_kaive DESC;
VASTUS:
| segment | klientide_arv | segmendi_keskmine_kaive | enim_vip_kliente_linnades                                               |
| ------- | ------------- | ----------------------- | ----------------------------------------------------------------------- |
| VIP     | 19            | 18227.01                | Tallinn (8), Pärnu (6), Tartu (2), Jõhvi (1), Rakvere (1), Viljandi (1) |
| Regular | 917           | 1615.43                 | -                                                                       |
| Uus     | 1615          | 492.30                  | -                                                                       |
-- VIP segmendis on 19 inimest, keskmine käive 18 227 € terve aja peale. 
-- Regular segmendis on 917 inimest, keskmine käive 1 615 € terve aja peale.
-- Uued segmendis on 1615 inimest, keskmine käive 492 € terve aja peale.
-- VIP klientide arvestus linnati on: Tallinn 8 klienti, Pärnu 6 klienti, Tartu 2 klienti, Jõhvi, Rakvere ning Viljandi 1 klient.

-- 4. Lisa window function kliendi järjestamiseks. Lisatud limiit iga linna top 5 kliendi leidmiseks. 
WITH kliendi_kokkuvote AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS kliendi_nimi,
        c.city,
        SUM(o.total_price) AS kogukäive,
        RANK() OVER (
            PARTITION BY c.city
            ORDER BY SUM(o.total_price) DESC
        ) AS koht_linnas
    FROM customers c
    JOIN sales o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city -- Lisatud nimeväljad grupeerimisse
),
segmenteeritud_kliendid AS (
    SELECT 
        customer_id,
        kliendi_nimi,
        city,
        kogukaive,
        koht_linnas,
        CASE 
            WHEN kogukäive > 5000 THEN 'VIP'
            WHEN kogukäive > 1000 THEN 'Regular'
            ELSE 'Uus' 
        END AS segment
    FROM kliendi_kokkuvote
)
SELECT 
    city AS linn,
    koht_linnas,
    customer_id AS kliendi_id,
    kliendi_nimi,
    segment,
    ROUND(kogukäive, 2) AS kliendi_kogukäive
FROM segmenteeritud_kliendid
WHERE koht_linnas <= 5
ORDER BY linn ASC, koht_linnas ASC;
-- VASTUS:
| linn       | koht_linnas | kliendi_id | kliendi_nimi   | segment | kliendi_kogukäive |
| ---------- | ----------- | ---------- | -------------- | ------- | ----------------- |
| Haapsalu   | 1           | 3035       | Grete Tamm     | Regular | 3185.20           |
| Haapsalu   | 2           | 4451       | Katrin Värk    | Regular | 2560.35           |
| Haapsalu   | 3           | 3608       | Tarmo Sepp     | Regular | 2496.09           |
| Haapsalu   | 4           | 3782       | Kristiina Sepp | Regular | 2350.16           |
| Haapsalu   | 5           | 2317       | Pille Raud     | Regular | 2142.56           |
| Jõhvi      | 1           | 4178       | Ago Lõoke      | VIP     | 19010.85          |
| Jõhvi      | 2           | 3470       | Raivo Nurk     | Regular | 3166.25           |
| Jõhvi      | 3           | 2343       | Tarmo Nõmm     | Regular | 3118.45           |
| Jõhvi      | 4           | 2174       | Piret Kask     | Regular | 2285.22           |
| Jõhvi      | 5           | 2755       | Merike Nõmm    | Regular | 2241.70           |
| Kuressaare | 1           | 4229       | Maris Luik     | Regular | 3434.64           |
| Kuressaare | 2           | 2558       | Hille Mets     | Regular | 2733.29           |
| Kuressaare | 3           | 2192       | Marit Talvik   | Regular | 2695.53           |
| Kuressaare | 4           | 2770       | Toomas Lõhmus  | Regular | 2662.20           |
| Kuressaare | 5           | 4418       | Margus Nõmm    | Regular | 2532.13           |
| Narva      | 1           | 3166       | Terje Lill     | Regular | 2859.45           |
| Narva      | 2           | 3305       | Urmas Raid     | Regular | 2502.82           |
| Narva      | 3           | 4365       | Jüri Sild      | Regular | 2305.84           |
| Narva      | 4           | 4373       | Ülle Org       | Regular | 2264.34           |
| Narva      | 5           | 2009       | Madis Mitt     | Regular | 2255.21           |
| Paide      | 1           | 2874       | Annika Valk    | Regular | 4091.60           |
| Paide      | 2           | 4585       | Lauri Männik   | Regular | 3287.58           |
| Paide      | 3           | 4452       | Grete Tamm     | Regular | 2343.75           |
| Paide      | 4           | 3939       | Enn Oja        | Regular | 2340.85           |
| Paide      | 5           | 3551       | Peeter Lill    | Regular | 2018.52           |
| Pärnu      | 1           | 3350       | Priit Rand     | VIP     | 26286.10          |
| Pärnu      | 2           | 2889       | Laura Tammik   | VIP     | 23385.82          |
| Pärnu      | 3           | 2221       | Riina Lill     | VIP     | 20972.33          |
| Pärnu      | 4           | 3722       | Ago Kull       | VIP     | 20124.61          |
| Pärnu      | 5           | 3810       | Pille Sepp     | VIP     | 18080.99          |
| Rakvere    | 1           | 4018       | Terje Kukk     | VIP     | 16145.97          |
| Rakvere    | 2           | 2397       | Kalev Puusepp  | Regular | 2847.68           |
| Rakvere    | 3           | 4255       | Liis Mägi      | Regular | 2594.27           |
| Rakvere    | 4           | 2744       | Piret Kull     | Regular | 2480.73           |
| Rakvere    | 5           | 3046       | Meelis Põld    | Regular | 2380.65           |
| Tallinn    | 1           | 2997       | Kevin Org      | VIP     | 23467.13          |
| Tallinn    | 2           | 3605       | Anu Kuusik     | VIP     | 21626.10          |
| Tallinn    | 3           | 4206       | Kersti Lill    | VIP     | 21137.47          |
| Tallinn    | 4           | 4949       | Marika Sepp    | VIP     | 19078.20          |
| Tallinn    | 5           | 3556       | Merike Vaher   | VIP     | 18332.28          |
| Tartu      | 1           | 3618       | Tiina Pärn     | VIP     | 27668.02          |
| Tartu      | 2           | 3648       | Erkki Ilves    | VIP     | 22942.42          |
| Tartu      | 3           | 3699       | Marko Pihl     | Regular | 4522.92           |
| Tartu      | 4           | 4076       | Merike Kangur  | Regular | 4471.93           |
| Tartu      | 5           | 4286       | Anna Org       | Regular | 3708.37           |
| Valga      | 1           | 2952       | Sandra Sild    | Regular | 2632.69           |
| Valga      | 2           | 2073       | Madis Roots    | Regular | 2233.70           |
| Valga      | 3           | 2197       | Sandra Nõmm    | Regular | 2231.40           |
| Valga      | 4           | 3394       | Eha Raid       | Regular | 2166.71           |
| Valga      | 5           | 2469       | Anu Kukk       | Regular | 2130.74           |
| Viljandi   | 1           | 2154       | Annika Saar    | VIP     | 20726.79          |
| Viljandi   | 2           | 2629       | Sandra Paas    | Regular | 3990.98           |
| Viljandi   | 3           | 4687       | Sirje Rand     | Regular | 3116.43           |
| Viljandi   | 4           | 2163       | Kadri Kull     | Regular | 2542.08           |
| Viljandi   | 5           | 4004       | Peeter Põld    | Regular | 2372.29           |
| Võru       | 1           | 3852       | Nele Kivi      | Regular | 2740.79           |
| Võru       | 2           | 3302       | Siim Toom      | Regular | 2567.91           |
| Võru       | 3           | 2863       | Maris Paas     | Regular | 2557.43           |
| Võru       | 4           | 4205       | Kristi Aas     | Regular | 2524.59           |
| Võru       | 5           | 4717       | Kevin Raud     | Regular | 2458.06           |
-- Leitud iga linna TOP5 klienti

-- 5.  Kliendid kes on teinud ühekordse ostu?
SELECT COUNT(*) AS ühe_ostuga_klientide_arv
FROM (
    SELECT customer_id
    FROM sales
    GROUP BY customer_id
    HAVING COUNT(sale_id) = 1
) AS kliendi_list;
-- 492 klienti on teinud Urbanstylist ainult ühe ostu. 

-- 6 Keskmine tellimusväärtus AOV?
SELECT 
    EXTRACT(YEAR FROM sale_date) AS aasta,
    ROUND(AVG(total_price), 2) AS keskmine_tellimuse_vaartus_AOV,
    COUNT(sale_id) AS tellimuste_koguarv,
    SUM(total_price) AS kogukaive
FROM sales
WHERE EXTRACT(YEAR FROM sale_date) IN (2025, 2026)
GROUP BY EXTRACT(YEAR FROM sale_date)
ORDER BY aasta ASC;

| aasta | keskmine_tellimuse_vaartus_aov | tellimuste_koguarv | kogukaive |
| ----- | ------------------------------ | ------------------ | --------- |
| 2025  | 289.39                         | 691                | 199968.69 |
| 2026  | 255.77                         | 16                 | 4092.37   |

-- Kliendi käibe konsentratsioon
WITH kliendi_aastane_kaive AS (
    -- 1. Samm: Arvutame iga kliendi kogukäibe aasta lõikes
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS aasta,
        customer_id,
        SUM(total_price) AS kliendi_kaive
    FROM sales
    WHERE EXTRACT(YEAR FROM sale_date) IN (2025, 2026)
    GROUP BY EXTRACT(YEAR FROM sale_date), customer_id
),
kliendi_groups AS (
    -- 2. Samm: Jagame kliendid igal aastal 10 gruppi (1 = TOP 10% suurimad kliendid)
    SELECT 
        aasta,
        kliendi_kaive,
        NTILE(10) OVER (PARTITION BY aasta ORDER BY kliendi_kaive DESC) AS kliendi_grupp
    FROM kliendi_aastane_kaive
),
aasta_kogukaive AS (
    -- 3. Samm: Arvutame iga aasta kogukäibe võrdluseks
    SELECT 
        aasta,
        SUM(kliendi_kaive) AS aasta_summa
    FROM kliendi_aastane_kaive
    GROUP BY aasta
)
-- 4. Samm: Arvutame TOP 10% klientide osakaalu kogu aasta käibest
SELECT 
    g.aasta,
    ROUND(SUM(g.kliendi_kaive), 2) AS top_10_protsendi_kaive,
    ROUND((SUM(g.kliendi_kaive) / k.aasta_summa) * 100, 2) AS kaibe_kontsentratsioon_protsent
FROM kliendi_groups g
JOIN aasta_kogukaive k ON g.aasta = k.aasta
WHERE g.kliendi_grupp = 1 -- Valib ainult TOP 10% kliendid
GROUP BY g.aasta, k.aasta_summa
ORDER BY g.aasta ASC;
| aasta | top_10_protsendi_kaive | kaibe_kontsentratsioon_protsent |
| ----- | ---------------------- | ------------------------------- |
| 2025  | 81855.72               | 40.93                           |
| 2026  | 1166.88                | 28.51                           |
