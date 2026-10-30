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
- Tempo reale: API E015 "GTFS Static e Real-time" di Trenord (ritardi effettivi alle fermate passate, ritardi previsti alle fermate future). Da verificare: registrazione/chiave, limiti di richieste, frequenza di aggiornamento.
- La pipeline notturna riduce il GTFS statico a un file compatto pubblicato su GitHub Pages; l'app legge il file compatto e il feed real-time direttamente.

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
- Dopo la partenza del treno: stato, ritardo, ETA stazione, ETA destinazione.
- Un treno cancellato resta visibile con stato chiaro di cancellato/soppresso.
- Treni senza dati real time: card con etichetta "Nessun dato real time per questo treno", visivamente distinta dalle card dei treni tracciati in tempo reale.
- Feed real-time irraggiungibile: messaggio di errore globale a livello di app, non etichetta per ogni treno.
- Indicatore di freschezza obbligatorio: "aggiornato alle HH:MM".
- Tasto "Termina" sulla card.
- Pulsante "sono salito su questo treno" (requisito funzionale; fase di realizzazione da decidere nella pianificazione della Fase 1).
- Nessun controllo sulla possibilità di portare la bici (in Lombardia tutti i treni la ammettono).

## Chiusura della Live Activity
- Chiusura automatica 10 minuti dopo la partenza prevista dell'ultimo treno utile della fascia.
- Dopo la conferma "sono salito": termina all'arrivo previsto + 5 minuti.
- Chiusura manuale con "Termina".
- Nota: la regola "10 minuti dopo l'ultimo treno" prevale sulla formulazione più sintetica "si chiude quando non restano treni" usata nella conversazione di approvazione; da riconfermare con l'utente se sembra in contrasto nell'uso reale.

## Avvio e calendarizzazione
- L'app è la fonte unica di viaggi, giorni, fasce e tempi.
- **Strada principale**: all'apertura mattutina l'app programma le Live Activity della giornata (andata e ritorno) con la funzione iOS 26; una sola automazione giornaliera di Comandi apre l'app.
- **Ripiego**: un'automazione di Comandi per ogni viaggio apre l'app all'ora scelta; al lancio l'app avvia subito la Live Activity e la finestra.
- La strada principale va validata in Fase 0 (anticipo massimo di programmazione, numero di attività, avviso all'avvio, esecuzione dell'app e posizione in background all'avvio programmato). Se non regge, il ripiego diventa principale.

## Schermate dell'app
- Home: nel viaggio corrente mostra tutti i treni precedenti e successivi (non solo i due della Live Activity) e permette di confermare la salita su ogni treno già partito.
- Senza viaggio corrente l'app si apre direttamente sull'elenco dei viaggi.

## Fasi
- **Fase 0 — spike con dati finti sul telefono**: programmazione iOS 26, posizione in background, durata dell'attività, batteria, rifirma ogni 7 giorni.
- **Fase 1 — MVP**: un viaggio fisso, un verso, dati reali, fascia oraria, due treni utili, "Esci tra", stati della card, "Termina". Tempo di percorrenza come configurazione statica. Criterio di successo: in una settimana reale di pendolarismo l'ETA mostrato corrisponde a quello visto in stazione.
- **Fase 2 — configurazione**: più viaggi, giorni, fasce, tempi di percorrenza modificabili, schermate di configurazione.
- **Fase 3 — rifiniture**: ETA stazione e destinazione.
