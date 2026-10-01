-- ============================================
-- Päring: Iseseisev töö nädal 1
-- Autor: Kertu Läänemägi
-- Kuupäev: 2026-09-30
-- Eesmärk: Vastata Toomase esitatud kõsimustele 
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


