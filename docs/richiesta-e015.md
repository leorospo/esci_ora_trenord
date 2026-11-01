# Richiesta di adesione E015 e accesso API Trenord

**Non inviata: E015 abbandonata il 2026-10-31 (D-29). Resta come riferimento per un eventuale uso futuro (backlog).**

Stato precedente: testo per il form (campi "Descrizione" e "Note" più un'immagine), versione dell'utente rivista (2026-10-31). Da inviare a cura dell'utente.

## Descrizione

Buongiorno,
mi chiamo Leonardo Mancori, sono uno UX/UI Designer e Developer basato a Monza e uso spesso il treno per i miei spostamenti.

Sto lavorando a un progetto personale: un'app per iPhone a uso privato, "Esci ora". Durante il tragitto casa-lavoro mostra sulla schermata di blocco i prossimi due treni disponibili e quanto tempo mi resta prima di dover uscire di casa per prenderli ("Esci tra 12 minuti").

Il progetto è personale e non commerciale: l'app non è distribuita né pubblicata sugli store, non ha altri utenti e non contiene pubblicità. Non ho in programma di trasformarla in un'app commerciale; se in futuro dovessi valutarlo, sono disponibile fin da ora a darvene comunicazione nel modo che riterrete più opportuno e, se necessario, a ripresentare l'adesione come azienda.

Aderisco da privato perché mi piacerebbe accedere ai dati in tempo reale di Trenord, così che l'app possa tenere conto dei ritardi e delle soppressioni reali e non solo dell'orario programmato.

Grazie per l'attenzione.

## Note

Considerata la natura del progetto, prevedo:

- **API**: "GTFS Static e Real Time v2.0" di Trenord S.r.l.
- **Uso**: lettura di ritardi e soppressioni per i treni di una tratta configurabile nell'app (principalmente Monza ↔ Cernusco-Merate), per circa due ore al giorno nei giorni feriali. Gli orari programmati saranno ricavati dal GTFS statico open data di Regione Lombardia, con la relativa attribuzione.
- **Volumi**: un solo dispositivo, con un aggiornamento ogni pochi minuti a ridosso dei viaggi programmati, cioè al massimo qualche decina di richieste al giorno. Mi adeguo volentieri alla frequenza che indicherete.

**Visualizzazione dei dati.** Ho letto la policy di utilizzo dei Dati Trenord nell'Ecosistema E015 (https://www.e015.regione.lombardia.it/site/download-policy?id=382), che richiede una specifica autorizzazione per l'utilizzo e la visualizzazione parziale dei dati. L'app mostra, per le stazioni di partenza e arrivo scelte, i prossimi treni con ritardi e soppressioni, e non l'intero contenuto del servizio. Se questo rientra nell'uso parziale, chiedo la relativa autorizzazione; in ogni caso resto disponibile ad adeguare la visualizzazione alle vostre indicazioni.

**Impegni rispetto alla policy:**
- nessuna modifica dei dati: ritardi e stati sono mostrati così come forniti; l'app calcola solo l'ora in cui uscire di casa a partire dall'orario previsto;
- nessuna storicizzazione: i dati restano in memoria solo per la durata del viaggio;
- nessun uso comparativo e nessuna pubblicità;
- fonte Trenord (logo) e ora dell'ultimo aggiornamento sempre visibili, secondo le vostre indicazioni;
- disponibilità a mostrare la nota di scarico di responsabilità di Trenord.

**Verifica da parte del Technical Management Board.** L'app non è distribuita (viene installata solo sul mio iPhone tramite Xcode), quindi posso mostrarla con un video o in una sessione da remoto e, se necessario, condividere schermate, descrizione tecnica e codice sorgente.
