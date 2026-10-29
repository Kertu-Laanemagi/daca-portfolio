# Nädal 5 – Individuaalne töö + Grupitöö

## Visualisatsioon Power BI

**DACA andmeanalüütiku programm | UrbanStyle**

##  Töö eesmärk

Viienda nädala eesmärk oli kasutada eelnevate nädalate SQL päringuid ja koostada Urbansstyle dashboard. 

##  Kasutatud andmetabelid

| Tabel | Kirjeldus |
|---|---|
| `sales` | Müügitehingud ja müügisummad |
| `customers` | Kliendid ja nende asukohad |
| `products` | Tooted ja inventuur |
| `turunduskanalid` | Turunduskanalite analüüsnädal 4 roll D |

- (Grupitöö esitluse fail)[https://docs.google.com/presentation/d/1bg1lFpKq04LwAn1vqwGZc_S45lVt2TCMeZ8oVTS-EaU/edit?slide=id.h713c66dd081386e0_0_1#slide=id.h713c66dd081386e0_0_1]

- (Grupitöö roll B)[Week-5/urbanstyle_week5_dashboard_GT_Kertu.pbix]

### Kasutatud võtted

Power Bi desktop appis koostatud interaktiivne dashboard UrbanStyle turunduskanalite analüüsist. Koostatud 3 joonist, mis kirjeldavad erinevaid näitajaid.võtmenäitajaid ajas muutuvatena. 
Interaktiivsuseks lisatud 2 filtrit: turunduskanalid ja ajaline periood kuude lõikes. Loodud 4 KPI näitamaks erinevaid turundusalaseid  näitajaid ajas muutuvana. 

### Disainiotsused
Dashboardi pealkirja puhul kasutatud Urbanstyle värvipaletti. 
Visuaali vasakus servas asuvatest filtritest valida rakendatav turunduskanal ja kuine periood. Mitmikvalik võimalik CRTL klahvi all hoides. Valitud filtrid rakendavad soovitud vaate andmetele - KPI ja visuaalid. 

**KPI seletused:**
AOV tähendab keskmist ostukorvi väärtust, mis näitab, kui palju raha kliendid ühe tellimuse kohta keskmiselt kulutavad. Võrdluseks kasutatud AOV mediaanväärtust.
Kuine kasvuprotsent  näitab, mitu protsenti on ettevõtte müügitulu ühe kuu jooksul võrreldes eelmise kuuga kasvanud või kahanenud. Positiivsed kasvud kujutatud rohelisega, negatiivsed punasega. 

Müük turunduskanali kohta  näitab, kui palju tulu on UrbanStyle teeninud konkreetse turunduskanali (näiteks sotsiaalmeedia, e-kirjade või otsingumootorireklaamide) kaudu.
Seostatud turundus (ehk tulemusturundus) tähendab müügikanali kontekstis mudelit, kus konkreetse turunduskanali tulemuslikkust mõõdetakse otse selle kaudu genereeritud müügitulu järgi .
Kohordi tihedus 30 päeva jooksul näitab, kui aktiivselt, korduvalt või tulemuslikult (näiteks ostudena) kindlal ajavahemikul liitunud tarbijagrupp ehk kohort esimese 30 päeva jooksul äriga suhestub.

**Joonise seletus:**

**Punktdiagramm** näitab AOV ja Kohordi tiheduse muutust leidmaks "Kuldpartnereid" ja "Ühekordseid suurkliente". 
- Kõrge AOV + Kõrge kohordi tihedus = Kuldpartnerid = täpid asuvad diagrammi üleval paremas nurgas
- Kõrge AOV + Madal kohordi tihedus = Ühekordsed suurkliendid = täpid asuvad diagrammi üleval vasakus nurgas.
- Madal AOV + Kõrge kohordi tihedus = Lojaalsed püsikliendid = täpid asuvad diagrammi all paremas nurgas.
- Madal AOV + Madal kohordi tihedus = Madala väärtusega liiklus =täpid asuvad diagrammi all vasakus nurgas.

**Tulpdiagramm** näitan kogutulu müügikanali jaotuses: E-pood ja tavapoed Tallinnas,Tartus ja Pärnus. 

**Joondeagramm** näitab uuet klientide hankimist ajaperioodis (kuine vaade).

#  Peamised ärilised järeldused
UrbanStyle keskendub hetkel turundusstrateegiana uute klientide värbamisele mitte klientide hoidmisele. AOV ja kahort on madalad, mis näitab, et enamus kliente ei ole pikaajalised ja ei tee kordusoste. 
Kõrgeima kohorditiheduse (0,8–1,1) ja ostukorviga (270–320€) segment on turunduskanaliga seostamata. 85% võrdlusandmetest viitab madalale kliendipidavusele – äri püsib vaid kulukal uute klientide hankimisel. 

#  Mida ma õppisin

Õppisin kasutama erinevaid joonise formaate ja neid modifitseerima. Kasutama tükeldi filtreid ja kohtspikreid andmaks rohkem informatsiooni ilma juhtimislauda ülekoormamata. 

## AI kasutus 

AI kasutus sellel nädalal oli ennekõike turundusteemalise materjali õppimise assisteerimiseks ja disainiotsuste pakkumiseks. Lasin AIl pakkuda välja sobivaid värvilahendusi ja tuua välja parim lahendus. 
