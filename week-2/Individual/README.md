# Week 2 – Individuaalne töö

## SQL andmete puhastamine

Week 2 iseseisva töö käigus harjutasin UrbanStyle andmebaasis SQL-i abil andmete kvaliteedi kontrollimist ja puhastamise ettevalmistamist.

### Tehtud tööd

- kontrollisin `sales` tabelis duplikaate;
- analüüsisin `customers` tabelis korduvaid e-posti aadresse;
- kontrollisin `products` tabeli duplikaate;
- kontrollisin puuduvaid ehk `NULL` väärtusi;
- kasutasin `COALESCE` funktsiooni puuduvate väärtuste käsitlemiseks;
- kontrollisin müügisummade kvaliteeti;
- vormindasin ja kontrollisin kuupäevi;
- kontrollisin ning standardiseerisin linnanimede kirjapilti;
- kontrollisin toodete hindu;
- koostasin andmekvaliteedi raporti.

### Peamised leiud

- `sales` tabelis on 15 234 rida ja 10 118 erinevat `sale_id` väärtust;
- duplikaatide mõju arvestuses on 5 116 üleliigset esinemist;
- `customers` tabelis on 380 puuduva e-posti aadressiga kirjet;
- 128 erinevat mitte-NULL e-posti aadressi esineb rohkem kui ühe korra;
- `products` tabelis ei leitud `product_id` duplikaate;
- `products` tabelis ei leitud NULL-, 0- ega negatiivse `retail_price` väärtusega tooteid;
- linnanimedel oli 54 erinevat algset kirjapilti, mis standardiseerusid 12 linnaks.
  Näiteks sama linn võis olla kirjutatud mitmel erineval viisil (suured/väikesed tähed, tühikud jne),
  mistõttu SQL luges need alguses erinevateks väärtusteks.

## SQL fail

Kõik Week 2 iseseisva töö SQL-päringud ja tulemuste kommentaarid asuvad nädala kaustas
