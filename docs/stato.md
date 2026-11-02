# Stato del progetto

Ultimo aggiornamento: 2026-11-02

## Fase corrente
Pre-Fase 0. Tempo reale da ViaggiaTreno con intestazioni da browser (D-32, D-33). In corso: pipeline del GTFS statico (overview approvata il 2026-11-02, Python, solo treni diretti). Nessun codice ancora scritto.

## Fatto
- Discussione di requisiti e architettura completata e approvata (vedi `decisioni.md`, D-01…D-20).
- Documenti iniziali del repository scritti.
- Design della Live Activity (schermata di blocco) fatto con Claude Design: versione C scelta, 156 pt. Modifiche registrate in D-21…D-28 e in `design.md`.
- Verifica V-01 (2026-10-31): l'API real-time Trenord sta solo dentro E015. Letti policy Trenord, contratto di adesione e Linee guida App (Allegato 1). E015 richiede approvazione discrezionale di Trenord, un server "App Broker" con certificati e la verifica del TMB: troppo lungo per un progetto da chiudere in pochi giorni. L'utente si è registrato a E015 ma **non ha inviato la richiesta né firmato il contratto**. La bozza di richiesta resta in `docs/richiesta-e015.md` come riferimento.
- Nessun feed real-time Trenord aperto trovato. Scelta ViaggiaTreno (API non ufficiale di Trenitalia) per uso personale, con i vincoli delle note legali (D-29, `requisiti.md`).
- La pipeline del GTFS statico, l'app e la verifica di ViaggiaTreno si possono fare in parte senza Mac.
- 2026-11-02: risposta di Trenitalia ricevuta (conservata dall'utente, non nel repository) → D-32, D-33. Integrati i requisiti della chat su Claude della mattina: capolinea del treno in Fase 1 (D-36), binario con il tempo reale (D-37). Pipeline: Python (D-34), solo diretti (D-35).
- Prototipo "senza tempo reale" (2026-11-02, branch `claude/prototipo-senza-tempo-reale`): il tempo reale resta nell'MVP, con ripiego sugli orari programmati se non si riesce a collegarlo (D-31).

## Prossimi passi
1. Pipeline del GTFS statico (GitHub Actions + Pages): overview approvata; verificare indirizzo del feed e codici delle stazioni sulle fonti ufficiali, poi test e codice. Il file compatto include il capolinea (D-36).
2. Rifare la prova di ViaggiaTreno (V-08) con intestazioni da browser, con e senza `From` (D-32); verificare anche il binario (V-09). Si fa senza Mac.
3. Valutare con l'utente l'impatto di capolinea e binario sul design della versione C (156 pt, max 160).
4. Aggiungere in `design.md` il link o l'export dei design.
5. Quando il Mac è disponibile (Claude deve chiederlo): Fase 0 sul suo iPhone 16.
6. Eventuale design della Dynamic Island (priorità bassa) e della card treno nell'app.

## Punti aperti
Vedi "Da verificare" in `decisioni.md` (V-02…V-08). Contatto per i titolari dei dati deciso (D-30): User-Agent e README.
