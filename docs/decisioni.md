# Registro delle decisioni

Formato: ID · data · decisione · motivo. Una decisione che ne sostituisce un'altra la cita.
Tutte le voci seguenti risalgono alla fase di discussione iniziale (2026-10-30) e sono state approvate dall'utente.

| ID | Data | Decisione | Motivo |
|---|---|---|---|
| D-01 | 2026-10-30 | App nativa iOS con Live Activity sulla schermata di blocco | Requisito principale dell'utente, aperto ad alternative ma questa regge |
| D-02 | 2026-10-30 | Nessun Apple Developer Program a pagamento; account gratuito e side loading (firma 7 giorni) | Spesa minima, progetto personale e come esercizio |
| D-03 | 2026-10-30 | Uso solo personale, nessun account | Semplicità; l'apertura ad altri sarebbe una fase separata |
| D-04 | 2026-10-30 | Dati orari da GTFS statico Trenord, tempo reale dall'API E015 GTFS-RT | Fonti ufficiali richieste dall'utente; licenza CC-BY 4.0 con attribuzione |
| D-05 | 2026-10-30 | Pipeline gratuita (GitHub Actions + Pages) riduce il GTFS a un file compatto; l'app legge anche il real-time direttamente | Sposta la complessità fuori da Swift, testabile senza telefono, gestisce il cambio orario |
| D-06 | 2026-10-30 | Repository GitHub pubblico | Dati già pubblici, Pages gratis, nessun segreto nel repo |
| D-07 | 2026-10-30 | Fase 0 (spike con dati finti) prima dell'MVP | La Live Activity senza push è il rischio tecnico maggiore |
| D-08 | 2026-10-30 | Posizione in background a precisione minima solo per tenere vivo il processo durante la finestra; nessuna funzione basata sul valore della posizione in v1 | Senza push gli aggiornamenti in background non sono garantiti; da misurare in Fase 0 (sostituisce la scelta iniziale "v1 senza posizione") |
| D-09 | 2026-10-30 | Avvio: strada principale = programmazione iOS 26 + una automazione giornaliera di Comandi; ripiego = Comandi per ogni viaggio | Meno impostazioni manuali; ripiego se la programmazione si rivela limitata |
| D-10 | 2026-10-30 | Calendarizzazione nell'app come fonte unica, non in Comandi | Un solo posto da modificare |
| D-11 | 2026-10-30 | Treno utile = partenza prevista ≥ ora corrente e dentro la fascia; il tempo luogo→stazione non lo esclude | L'app non sa se l'utente è già uscito (a piedi o in bici); evita ulteriori Comandi |
| D-12 | 2026-10-30 | Informazione principale: "Esci tra XX minuti" (prima "esci entro le XX:XX"), su partenza prevista, arrotondato per difetto; "Esci ora" in stile urgente | Chiarezza a colpo d'occhio; il conto alla rovescia scorre da solo |
| D-13 | 2026-10-30 | Chiusura 10 min dopo l'ultimo treno utile; dopo "sono salito" all'arrivo previsto + 5 min; tasto "Termina" | Regole concordate con l'utente |
| D-14 | 2026-10-30 | Treni senza real time: etichetta dedicata e card distinta; feed irraggiungibile: errore globale | Distinguere dati affidabili da quelli solo programmati |
| D-15 | 2026-10-30 | Indicatore "aggiornato alle HH:MM" sulla card | Senza push il ritardo non è sempre fresco |
| D-16 | 2026-10-30 | Pulsante "sono salito su questo treno" è un requisito funzionale; nuovi stati della card dopo la selezione vanno in backlog | Richiesta dell'utente |
| D-17 | 2026-10-30 | Nessuna esperienza Swift: codice interamente delegato a Claude Code; design con Claude Design sotto guida, utente partecipa; overview prima di ogni fase, niente codice mostrato salvo necessità | Obiettivo di imparare il processo, non Swift |
| D-18 | 2026-10-30 | Per ora in Claude Design solo la Live Activity; configurazione in Fase 2 | Limite d'uso condiviso tra Claude, Claude Design e Claude Code |
| D-19 | 2026-10-30 | Si parte su Windows; Claude chiede se il Mac è disponibile quando servono passaggi che lo richiedono | Mac non disponibile per alcuni giorni |
| D-20 | 2026-10-30 | Repository come fonte di verità, con docs/ e CLAUDE.md; nessuna modifica senza aggiornare il documento corrispondente | Allineamento completo tra stato del progetto e AI |

## Da verificare (aperti)
- V-01: registrazione/chiave, limiti e frequenza dell'API real-time E015.
- V-02: anticipo massimo e numero di Live Activity programmabili su iOS 26; esecuzione dell'app all'avvio programmato.
- V-03: affidabilità di aggiornamento in background con posizione a precisione minima, consumo batteria, durata massima di una Live Activity.
- V-04: se account gratuito consente app + estensione Live Activity senza limiti inattesi e se serve uno strumento di rifirma (AltStore o simili).
- V-05: GitHub Pages con repository pubblico, piano gratuito.
