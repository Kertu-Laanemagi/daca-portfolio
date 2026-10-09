# Nädal 2: SQL-andmete kvaliteedikontroll ja puhastamine

## Mida ma õppisin

Teisel nädalal õppisin SQL-i abil kontrollima andmete kvaliteeti, leidma puuduvaid ja korduvaid väärtusi ning ühtlustama andmete kirjapilti.

Harjutasin UrbanStyle'i andmebaasi tabelitega `sales`, `customers` ja `products`. Sain aru, miks on oluline enne andmete puhastamist teha kontrollpäringuid ja säilitada originaalandmed muutmata.

## SQL-teemad

- Puuduvate väärtuste leidmine (`NULL`, `IS NULL`)
- Korduvate väärtuste kontrollimine (`GROUP BY`, `HAVING`, `COUNT`)
- Erinevate väärtuste uurimine (`DISTINCT`)
- Tekstiväärtuste ühtlustamine
- Andmete parandamine testtabelis (`UPDATE`)
- Kontrollpäringute tegemine enne ja pärast puhastamist

## Minu individuaalne töö

Minu põhiülesanne oli `products` tabeli andmekvaliteedi kontrollimine ja puhastamine.

Kontrollisin puuduvaid tooteandmeid, korduvaid toote nimetusi ning kriitiliste väärtuste puuduvaid väärtusi.

Töötasin `products_test` tabeliga, et algne `products` tabel jääks muutmata.

Individuaalse töö SQL-päringud, aruanne ja ekraanipildid asuvad lingil [week-2/Team/Week2_cleaning_products.sgl]

## Meeskonnatöö

Kuulusin meeskonda **Toode** koos Helen Starodubtseva ja Ivo Mureliga.

### Tööjaotus

- **Ivo Murel:** `sales` tabel
- **Helen Starodubtseva:** `customers` tabel
- **Kertu Läänemägi:** `products` tabel

Koostasime ühise andmekvaliteedi raporti ja kogusime SQL-päringute tulemuste ekraanipildid.

Meeskonnatöö kirjeldus ja link ühisele GitHubi hoidlale asuvad failis [week2_data_cleaning.md](team/week2_data_cleaning.md).

## Kokkuvõte

Teisel nädalal sain praktilise kogemuse SQL-andmete kvaliteedi hindamisel ja puhastamisel. Õppisin, et andmete parandamise kõrval on oluline ka muudatuste kontrollimine, dokumenteerimine ja meeskonnatöö.
