# Week 8 - API(ETL)

## Iseseisev töö

Läbisin Iseseisvatöö juhendi järgi. RFM analüüs ja RFM pipeline harjutus. Lisatud koodifail. 

## Grupitöö API (ETL) pipeline protsess

### Roll D - Automatiseerimine ja pipeline

Minu roll D oli koostada pipeline kood, mis võtab tiimikaaslaste poolt koostatud failid ja ühendab need üheks sujuvaks automaatseks protsessiks. 
Kasutatud on logger teeki logi loomiseks, smtplib saadab e-kirju , pathlib teeb failihaldust ja mimetext koostab emaili teksti. 

**Koodi blokkide selgitus:**
- Impordib kõik vajalikud teegid
- Impordib vajalikud dataframid ROll A, B ja C failidest.
- Loob tagavara andmefailid juhuks kui Supabase on kättesaamatu
- Loggeri mooduli spetsifikatsioon
- Kood teavituste saatmiseks: simulatsioon teavituste saatmise kohta emailile ja Google Chati.
-  ETL pipeline retry konfiguratsioon - 3 korda proovimist.
-  ETL pipeline järjendus: pipeline osade käivitus, logging, data extract, transform, visualise ja salvestus.
-  Kokkuvõtte andmed
  
AI kasutus: AI abim kasutasin pipeline koodi kirjutamisel ja täpse ülesehituse seletamisel.
AI aitas paigutada pipeline elemendid loogilisse järjekorda, et iga protsess toimiks täpselt õigel ajal.
