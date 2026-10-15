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

-- Kui palju on "Kadunud" kliente? _crypto_aead_det_decryptSELECT COUNT(*) AS kadunud_kliente
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
