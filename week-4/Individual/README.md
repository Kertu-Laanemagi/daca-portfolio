# Nädal 4 – Individuaalne töö

## SQL agregatsioon ja andmete analüüs

**DACA andmeanalüütiku programm | UrbanStyle**

##  Töö eesmärk

Neljanda nädala eesmärk oli õppida SQL-i abil andmeid grupeerima, filtreerima ja analüüsima, kasutades erinevaid päringuid.

##  Kasutatud andmetabelid

| Tabel | Kirjeldus |
|---|---|
| `sales` | Müügitehingud ja müügisummad |
| `customers` | Kliendid ja nende asukohad |
| `products` | Tooted ja tootekategooriad |

### Kasutatud SQL-võtted

| SQL-võte | Eesmärk |
|---|---|
| `COUNT()` | Kirjete loendamine |
| `SUM()` | Müügikäibe arvutamine |
| `AVG()` | Keskmiste väärtuste arvutamine |
| `GROUP BY` | Andmete grupeerimine |
| `WHERE` | Andmete filtreerimine |
| `HAVING` | Grupeeritud tulemuste filtreerimine |
| `JOIN` | Tabelite ühendamine |
| `WITH` (CTE) | Mitmeastmeliste päringute koostamine |
| `CASE` | Klientide segmenteerimine |
| `LAG()` | Müügitrendide võrdlemine |
| `RANK()` | Linnade järjestamine |
| `PARTITION BY` | Järjestamine kategooriate kaupa |

#  CEO raport – müügitulemused juhtkonnale

## TOP 5 linna müügikäibe järgi

| Koht | Linn | Kogukäive | Tellimusi |
|---|---|---:|---:|
| 1 | **Tallinn** | **571 649,39 €** | **2062** |
| 2 | Tartu | 292 500,31 € | 1011 |
| 3 | Pärnu | 226 008,72 € | 755 |
| 4 | Narva | 67 458,67 € | 233 |
| 5 | Viljandi | 60 339,62 € | 215 |

**Järeldus:** Tallinn on suurima müügikäibe ja tellimuste arvuga linn.


## Lisaülesanne 1 – Linnade osakaal kogukäibest

**Kasutatud SQL:** `SUM() OVER ()`.

| Linn | Osakaal |
|---|---:|
| Tallinn | 37,94% |
| Tartu | 19,41% |
| Pärnu | 15,00% |
| Narva | 4,48% |
| Viljandi | 4,00% |

**Peamine tulemus:** Tallinn, Tartu ja Pärnu moodustasid kokku **72,35% analüüsitud linnade kogukäibest**.

**Järeldus:** suurem osa müügikäibest koondus kolme linna.

## Lisaülesanne 2 – Viimase kuu käibe võrdlus

| Näitaja | Tulemus |
|---|---:|
| Viimase andmetes esineva kuu käive | **1408,72 €** |
| Varasemate kuude keskmine käive | **83 650,52 €** |
| Erinevus | **−98,3%** |

**Järeldus:** viimase kuu käive oli varasemate kuude keskmisest oluliselt väiksem.

**Oluline:** 2026. aasta müügiandmed võivad olla puudulikud. Seetõttu ei saa kindlalt väita, et ettevõtte tegelik müük langes 98,3%.

### Järeldus

Andmekvaliteet mõjutab otseselt analüüsi usaldusväärsust.

Enne äriliste otsuste tegemist tuleb kontrollida, kas andmed on täielikud ja kas võrreldavad perioodid on sobivad.


#  Peamised ärilised järeldused

1. **Müügikäive koondub suurematesse linnadesse.** Tallinn, Tartu ja Pärnu moodustasid 72,35% analüüsitud linnade kogukäibest.

2. **Tootekategooriate nõudlus on erinev.** Kõige rohkem müüdi meeste riiete kategooria tooteid.

3. **Klientide ostumahud erinevad.** Segmenteerimine aitab kavandada sobivaid pakkumisi erinevatele kliendirühmadele.

4. **Müügitrende tuleb tõlgendada ettevaatlikult.** Suured protsentuaalsed muutused võivad tuleneda väikesest võrdlusbaasist või puudulikest andmetest.

5. **Puuduvad kliendi ID-d mõjutavad aruannete täpsust.** Kokku oli 988 müügirida, mida ei saanud konkreetse kliendiga siduda.

#  Mida ma õppisin

Neljandal nädalal õppisin:

- kasutama SQL-i agregaatfunktsioone;
- grupeerima ja filtreerima andmeid;
- eristama `WHERE` ja `HAVING` kasutamist;
- koostama CTE-päringuid;
- analüüsima müügitrende `LAG()` abil;
- järjestama linnu `RANK()` abil;
- arvutama müügikäibe osakaale;
- kontrollima puuduvaid väärtusi;
- tõlgendama SQL-tulemusi ärilisest vaatenurgast.

---

