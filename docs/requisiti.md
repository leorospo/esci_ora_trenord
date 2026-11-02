# Requisiti

Stato: approvati dall'utente il 2026-10-30 (overview confermata). Ogni modifica va riportata anche in `decisioni.md`.

## Obiettivo
Vedere rapidamente e **senza alcun input** i prossimi treni utili per il proprio viaggio (andata o ritorno) sulla schermata di blocco dell'iPhone, tramite Live Activity.

## Vincoli di progetto
- Spesa minima: nessun Apple Developer Program a pagamento; pipeline dati gratuita (GitHub Actions + GitHub Pages).
- MVP funzionante il prima possibile.
- Esercizio di processo progettuale e implementativo guidato dall'AI (Claude Design, Claude Code); stato del progetto sempre allineato con l'AI.
- Uso solo personale, nessun account né altri utenti.
- Dispositivo: iPhone 16, iOS 26.5.2. App nativa iOS, distribuzione in side loading.

## Dati
- Orari: GTFS statico Trenord (open data Regione Lombardia, CC-BY 4.0, attribuzione obbligatoria). Validità attuale fino al 2026-12-12; serve ricaricare il feed al cambio orario.
- Tempo reale: API non ufficiale di ViaggiaTreno (Trenitalia), interrogata direttamente dall'app sul telefono (vedi D-29). Vincoli dalle note legali: solo uso personale e informativo; i dati non vengono ripubblicati né distribuiti (né dalla pipeline né su GitHub Pages né nel repository); nessuno storico; nessun uso del nome o del logo ViaggiaTreno nell'app; richieste poche e solo durante le finestre di monitoraggio. Se l'API non risponde o cambia, l'app passa agli orari programmati. Le richieste usano le intestazioni HTTP di un normale browser, più l'intestazione `From` con il contatto anonimo (morena.piste.0f@icloud.com) solo se la prova dimostra che non causa blocchi (D-32). Durante la finestra di monitoraggio una richiesta ogni 90 secondi con variazione casuale di ±15 secondi (D-33). Se Trenitalia chiede di smettere, o il servizio torna a bloccare, l'interrogazione si ferma e l'app usa gli orari programmati.
- La pipeline notturna riduce il GTFS statico a un file compatto pubblicato su GitHub Pages; l'app legge il file compatto e, direttamente, i ritardi da ViaggiaTreno.
- Solo treni diretti tra stazione di partenza e di arrivo, nessun viaggio con cambio (D-35).

## Concetti
- **Viaggio**: solo andata o solo ritorno. Campi: stazione di partenza, stazione di arrivo, fascia oraria di partenza dalla stazione, tempo luogo di partenza→stazione, tempo stazione→destinazione, "Inizio monitoraggio" (monitoraggio a partire da X prima della fascia, default 90 minuti), giorni della settimana come le sveglie.
- **Fascia oraria**: intervallo di partenza dalla stazione preimpostato nel viaggio.
- **Treno utile**: partenza prevista (programmata più ritardo) non ancora passata E dentro la fascia. Un treno programmato prima della fascia ma in ritardo che rientra nella fascia è utile. Il tempo luogo→stazione NON entra nella selezione (l'app non sa se l'utente è già uscito).
- **Viaggio corrente**: da "Inizio monitoraggio" fino alla chiusura della Live Activity.
- **Finestra di monitoraggio**: periodo in cui l'app resta attiva in background (posizione a precisione minima) e aggiorna la card.

## Live Activity (schermata di blocco)
- Mostra i due treni utili successivi della fascia; una sola card se ne resta uno.
- Informazione principale per ogni treno: **"Esci tra XX minuti"** = partenza prevista − tempo di percorrenza luogo→stazione − ora corrente. Usa la partenza programmata se mancano dati real time. Minuti arrotondati per difetto. Il conto alla rovescia scorre da solo.
- Quando il valore è zero o passato e il treno non è partito: **"Esci ora"** in stile urgente.
- Contenuto della card treno (dettaglio in `design.md`): numero del treno, durata del viaggio, partenza → arrivo previsti (con ritardo solo l'orario aggiornato), capolinea del treno per riconoscerlo sul tabellone (D-36, impatto sul design da valutare), binario di partenza se disponibile dal tempo reale (D-37), stato sempre visibile ("In orario", "+N min", "Senza real time"). "Esci tra" sta in una colonna a destra. La stazione di destinazione non è per card: la tratta compare una volta sola nel piede.
- Altezza massima della Live Activity: 160 pt (versione scelta: 156 pt).
- Dopo la partenza del treno: stato, ritardo, ETA stazione, ETA destinazione.
- Un treno cancellato resta visibile con stato chiaro di cancellato/soppresso.
- Treni senza dati real time: etichetta breve "Senza real time" con icona, bordo tratteggiato e "~" sui minuti, visivamente distinta dalle card dei treni tracciati. La frase completa "Nessun dato real time per questo treno" sta nella card treno dentro l'app.
- Feed real-time irraggiungibile: messaggio di errore globale, non etichetta per ogni treno. Nella Live Activity sostituisce la riga del piede: "⚠ Tempo reale non raggiungibile · agg. HH:MM".
- Indicatore di freschezza obbligatorio: "Aggiornato alle HH:MM", nel piede a destra della tratta.
- Nessun pulsante nella Live Activity: la chiusura è il gesto standard di iOS (vedi sotto).
- "Sono salito su questo treno": requisito funzionale, ma sta nella card treno dentro l'app, non nella Live Activity. Fase di realizzazione da decidere nella pianificazione della Fase 1.
- Nessun controllo sulla possibilità di portare la bici (in Lombardia tutti i treni la ammettono).

## Chiusura della Live Activity
- Chiusura automatica 10 minuti dopo la partenza prevista dell'ultimo treno utile della fascia.
- Dopo la conferma "sono salito": termina all'arrivo previsto + 5 minuti.
- Chiusura manuale: swipe standard di iOS sulla Live Activity. L'app osserva lo stato dell'attività e, se chiusa dall'utente, interrompe il monitoraggio e la posizione in background (da verificare in Fase 0, V-06).
- Nota: la regola "10 minuti dopo l'ultimo treno" prevale sulla formulazione più sintetica "si chiude quando non restano treni" usata nella conversazione di approvazione; da riconfermare con l'utente se sembra in contrasto nell'uso reale.

## Avvio e calendarizzazione
- L'app è la fonte unica di viaggi, giorni, fasce e tempi.
- **Strada principale**: all'apertura mattutina l'app programma le Live Activity della giornata (andata e ritorno) con la funzione iOS 26; una sola automazione giornaliera di Comandi apre l'app.
- **Ripiego**: un'automazione di Comandi per ogni viaggio apre l'app all'ora scelta; al lancio l'app avvia subito la Live Activity e la finestra.
- La strada principale va validata in Fase 0 (anticipo massimo di programmazione, numero di attività, avviso all'avvio, esecuzione dell'app e posizione in background all'avvio programmato). Se non regge, il ripiego diventa principale.

## Schermate dell'app
- Home: nel viaggio corrente mostra tutti i treni precedenti e successivi (non solo i due della Live Activity) e permette di confermare la salita su ogni treno già partito ("Sono salito" è nella card treno dell'app). La card dell'app mostra anche la frase completa per i treni senza dati real time.
- Senza viaggio corrente l'app si apre direttamente sull'elenco dei viaggi.

## Fasi
- **Fase 0 — spike con dati finti sul telefono**: programmazione iOS 26, posizione in background, durata dell'attività, batteria, rifirma ogni 7 giorni.
- **Fase 1 — MVP**: un viaggio fisso, un verso, dati reali, fascia oraria, due treni utili, "Esci tra", stati della card. Tempo di percorrenza come configurazione statica. Capolinea del treno (dal GTFS statico). Binario di partenza insieme al collegamento del tempo reale, se il dato è disponibile. Criterio di successo: in una settimana reale di pendolarismo l'ETA mostrato corrisponde a quello visto in stazione.
- **Fase 2 — configurazione**: più viaggi, giorni, fasce, tempi di percorrenza modificabili, schermate di configurazione.
- **Fase 3 — rifiniture**: ETA stazione e destinazione.
