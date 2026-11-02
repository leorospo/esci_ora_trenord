# App iOS: Fase 0 (spike con dati finti)

App minima con estensione della Live Activity. Serve a rispondere sul telefono alle verifiche V-02, V-03, V-04 e V-06 (`docs/decisioni.md`). Dati finti: nessuna richiesta a ViaggiaTreno né a `orari.json`.

Il codice è stato scritto su Windows senza compilarlo (D-51): alla prima compilazione sul Mac potrebbero emergere errori da correggere.

## Struttura
- `project.yml`: descrizione del progetto per XcodeGen, che genera `EsciOra.xcodeproj` (non nel repository).
- `Shared/`: dati della Live Activity, usati da app ed estensione.
- `App/`: l'app con i comandi di prova, il registro degli eventi, la posizione in background, l'azione per Comandi e i treni finti.
- `Widget/`: l'estensione con la card della Live Activity (struttura dell'Iter. 4, aspetto approssimato).

## Sul Mac, la prima volta
1. Installare Xcode 26 dall'App Store e aprirlo una volta.
2. Installare Homebrew (https://brew.sh), poi XcodeGen: `brew install xcodegen`.
3. Clonare il repository, entrare nella cartella `app` ed eseguire `xcodegen generate`.
4. Aprire `EsciOra.xcodeproj`.
5. In Xcode → Settings → Accounts aggiungere l'Apple Account gratuito.
6. Per entrambi i target (EsciOra ed EsciOraWidget), scheda "Signing & Capabilities": scegliere il team "Personal Team". Se il bundle identifier è già in uso, cambiarlo in `project.yml` e rigenerare. Per non ripetere la scelta a ogni `xcodegen generate`, aggiungere il proprio Team ID come `DEVELOPMENT_TEAM` in `settings.base` di `project.yml`.
7. Collegare l'iPhone, attivare la Modalità sviluppatore (Impostazioni → Privacy e sicurezza) e avviare l'app da Xcode.
8. Sull'iPhone: Impostazioni → Generali → VPN e gestione dispositivi → autorizzare il proprio account sviluppatore.

Ogni 7 giorni il profilo scade: ripetere il passo 7 (V-04).

## Le prove (ordine dell'overview approvata)
Nell'app, prima di tutto "Chiedi autorizzazione" per la posizione, poi in Impostazioni portarla su "Sempre".
1. **Avvio manuale**: "Avvia ora". La Live Activity compare sulla schermata di blocco; il piede mostra "#N", che cresce a ogni aggiornamento.
2. **Programmazione** (V-02): scegliere 1 minuto, 10 minuti, 1 ora, 12 ore, 24 ore e "Programma". Annotare se compare l'avviso, se parte all'ora giusta e se nel registro compare "Processo avviato" e "Monitoraggio avviato" all'avvio, e se poi gli aggiornamenti continuano. La posizione avviata con l'app in background è il punto più incerto: vale anche per la prova 3.
3. **Ripiego con Comandi** (V-02): in Comandi creare un'automazione oraria con l'azione "Avvia monitoraggio treni", da eseguire senza conferma. Verificare che la Live Activity parta senza aprire l'app.
4. **Background** (V-03): bloccare il telefono per 2 ore. Nel registro gli aggiornamenti devono arrivare circa ogni 90 secondi anche con l'app in background.
5. **Batteria** (V-03): ogni riga del registro riporta la carica; confrontare inizio e fine della finestra.
6. **Swipe** (V-06): chiudere la Live Activity con lo swipe. Nel registro devono comparire "rimossa", "Monitoraggio fermato" e "Posizione fermata". Provare anche con una seconda Live Activity programmata.
7. **Firma** (V-04): annotare il giorno di installazione e verificare che dopo 7 giorni l'app non si apra più.

Il registro si condivide con il pulsante in alto a destra (per esempio in una nota o in chat con Claude).

## Treni finti
Un treno ogni 30 minuti, il primo 20 minuti dopo l'avvio. A ogni aggiornamento cambiano gli stati per vederli tutti: ritardi, binario confermato e cambiato, treno senza real time, soppresso. La card esce 5 minuti dopo la partenza (D-41).
