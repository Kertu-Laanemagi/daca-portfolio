---
## Kertu – Customers (Roll B)

**Domeen:** Kliendid  `customer`

### Peamised leiud


### SQL-analüüs

**1. Kliendigruppide analüüs CTE, iga kliendi kogukulutus ja segmenteerimine**

Ühendasin `sales` ja `customer` tabelid ning arvutasin iga kliendi kogukulutuse ning leidsin segmendi.

**Tulemus:**  
| Segment| Kliente | Keskmine_kulu|
|---|---|---|
| VIP | 19 | 18 227 € |
| Regular | 917 | 1 615 € |
| Tavaline | 1615| 492 €|

**2. TOP 10 klienti kogukulu järgi**

Kasutasin `COUNT ()`, `SUM()`, `GROUP BY`,`HAVING` ja `ORDER BY`  päringuid, et leida TOP 10 klienti, kes on sooritanud oste suurimas kogusummas.

**Tulemus:** Leitud 10 kõige suurema  koguostusummaga klienti.

| customer_id | kliendi_nimi | tellimuste_arv | kogukulu |
| ----------- | ------------ | -------------- | --------- |
| 3618        | Tiina Pärn   | 73             | 27 668.02  |
| 3350        | Priit Rand   | 76             | 26 286.10  |
| 2997        | Kevin Org    | 78             | 23 467.13  |
| 2889        | Laura Tammik | 74             | 23 385.82  |
| 3648        | Erkki Ilves  | 72             | 22 942.42  |
| 3605        | Anu Kuusik   | 77             | 21 626.10  |
| 4206        | Kersti Lill  | 71             | 21 137.47  |
| 2221        | Riina Lill   | 67             | 20 972.33  |
| 2154        | Annika Saar  | 66             | 20 726.79  |
| 3722        | Ago Kull     | 64             | 20 124.61  |

**3. Kliendisegmentide koondstatistika**

Kasutasin `COUNT()`, `SUM()`, `GROUP BY` ja `ORDER BY` päringuid jagamaks kliente segmentidesse. Piirid arvestatud week 3 leitud keskmise ostusumma järgi, mis oli 1 140 €
Piirid:
a) VIP kogukulu > 5000 €
b) Regular 5000 € < kogukulu >1000 €
c) Tavaline kogukulu < 1000 €

**Tulemus:** 
| Segment | Klientide_arv | Segmendi_keskmine_kaive |
| ------- | ------------- | ----------------------- |
| VIP     | 19            | 18 227.01               |
| Regular | 917           | 1 615.43                |
| Tavaline   | 1615          | 492.30                  |

**4. Segmentide koondstatistika**

Leidsin kõigi 3 segmendi keskmise käibe. Lisaks leidsin, millistes linnades on kõige rohkem VIP kliente. 

**Tulemus:**
| segment  | klientide_arv | segmendi_keskmine_kaive | enim_vip_kliente_linnades                                               |
| -------  | ------------- | ----------------------- | ----------------------------------------------------------------------- |
| VIP      | 19            | 18227.01                | Tallinn (8), Pärnu (6), Tartu (2), Jõhvi (1), Rakvere (1), Viljandi (1) |
| Regular  | 917           | 1615.43                 | -                                                                       |
| Tavaline | 1615          | 492.30                  | -                                                                       |

**5. Iga linna kohta leitud 5 top klienti, kliendisegment ja kogukulu**

Kasutasin `ROUND()`, `SUM()`, `GROUP BY`,`ORDER BY`, `RANK` ja `CASE WHEN` päringuid, et leida esmalt kõikide klientide kogukulu ja linn, seejärel ägada need segmentideks ning leida igalinna kohta top 5 VIP klienti järjestatuna kogukulu järgi.  

**Tulemus:** Iga linna kohta leitud VIP klientide järjestus, Piiratud tulemusi iga linna kohta 5ga. 

### Suurim üllatus
 

### Soovitused Kristile
* Kasvatada VIP kientide lojaalsusprogrammi luues eraldi personaalse ja eksklusiivse teeninduse. Näiteks individuaalne suhtlus, eelisjuurdepääs uutele kollektsioonidele, stiilinõustamine.
* Aktiivse segmendi ehitamine VIP-ks läbi sihtmärgistatud progresseerivate pakkumiste. Need stimuleerivad keskmise ostukorvi kasvu ja sagedust.
* Näidata investoritele selget kliendiredelit: kuidas tavakliendist saab 1000 € künnise ületamisel Aktiivne klient ja sealt edasi 5000 € künnisega VIP.  See tõestab toimivat klienditeekonda ja stabiilset rahakäibet. 


| Näitaja | 2024 | 2025 | 2026 |
| --- | --- | --- | ---|
|Keskmine tellimusväärtus (AOV)| 286 € | 289 € | 255 € |
|Kliendi käibekonsentratsioon | 45% |41% | 28% |


| aasta | keskmine_tellimuse_vaartus_aov | tellimuste_koguarv | kogukaive   |
| ----- | ------------------------------ | ------------------ | ----------  |
| 2024  | 286.23 €                       | 5137               | 1470 358.02 €|
| 2025  | 289.39 €                       | 691                | 199 968.69 € |
| 2026  | 255.77 €                       | 16                 | 4 092.37 €   |

| aasta | top_10_protsendi_kaive | kaibe_kontsentratsioon_protsent |
| ----- | ---------------------- | ------------------------------- |
| 2024  | 664 191.05 €           | 45.17 €                          |
| 2025  | 81 855.72 €            | 40.93 €                         |
| 2026  | 1 166.88 €             | 28.51 €                          |
