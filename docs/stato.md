# Stato del progetto

Ultimo aggiornamento: 2026-11-02

## Fase corrente
Pre-Fase 0. Tempo reale da ViaggiaTreno con intestazioni da browser (D-32, D-33), verificato dal PC locale il 2026-11-02. Pipeline del GTFS statico attiva su `master` e GitHub Pages (D-38…D-40), primo giro riuscito il 2026-11-02. Nessun codice dell'app ancora scritto.

## Fatto
- Discussione di requisiti e architettura completata e approvata (vedi `decisioni.md`, D-01…D-20).
- Documenti iniziali del repository scritti.
- Design della Live Activity (schermata di blocco) fatto con Claude Design: versione C scelta, 156 pt. Modifiche registrate in D-21…D-28 e in `design.md`.
- Verifica V-01 (2026-10-31): l'API real-time Trenord sta solo dentro E015. Letti policy Trenord, contratto di adesione e Linee guida App (Allegato 1). E015 richiede approvazione discrezionale di Trenord, un server "App Broker" con certificati e la verifica del TMB: troppo lungo per un progetto da chiudere in pochi giorni. L'utente si è registrato a E015 ma **non ha inviato la richiesta né firmato il contratto**. La bozza di richiesta resta in `docs/richiesta-e015.md` come riferimento.
- Nessun feed real-time Trenord aperto trovato. Scelta ViaggiaTreno (API non ufficiale di Trenitalia) per uso personale, con i vincoli delle note legali (D-29, `requisiti.md`).
- La pipeline del GTFS statico, l'app e la verifica di ViaggiaTreno si possono fare in parte senza Mac.
- 2026-11-02: risposta di Trenitalia ricevuta (conservata dall'utente, non nel repository) → D-32, D-33. Integrati i requisiti della chat su Claude della mattina: capolinea del treno in Fase 1 (D-36), binario con il tempo reale (D-37). Pipeline: Python (D-34), solo diretti (D-35).
- Prototipo "senza tempo reale" (2026-11-02, branch `claude/prototipo-senza-tempo-reale`): il tempo reale resta nell'MVP, con ripiego sugli orari programmati se non si riesce a collegarlo (D-31).

- Prova di ViaggiaTreno dal PC locale (2026-11-02): funziona con intestazioni da browser e `From`; binario disponibile; numeri dei treni uguali a `orari.json`. V-08 e V-09 chiuse. Campi e casi di soppressione in `docs/viaggiatreno.md`.
- Nota per gli agenti: in modalità auto il controllo dei permessi di Claude Code blocca le richieste a ViaggiaTreno con intestazioni da browser, perché non conosce D-32. L'utente ha aggiunto una regola di permesso locale in `.claude/settings.local.json` (cartella esclusa da git). In un nuovo ambiente, per esempio il cloud o il Mac, va aggiunta di nuovo.

- Regole della card dopo la partenza e della chiusura (D-41…D-43). Decisioni del grilling di design sulla Live Activity registrate (D-44…D-50) e `design.md` riscritto con il link al design (Iter. 4).

## Prossimi passi
1. ~~V-05~~ chiusa il 2026-11-02: `orari.json` raggiungibile su https://leorospo.github.io/esci_ora_trenord/orari.json.
2. ~~Prova di ViaggiaTreno (V-08, V-09)~~ chiusa il 2026-11-02.
3. ~~Design per capolinea e binario~~ fatto (Iter. 4, D-44…D-50).
4. ~~Link del design in `design.md`~~ fatto.
5. Quando il Mac è disponibile (Claude deve chiederlo): Fase 0 sul suo iPhone 16.
6. Eventuale design della Dynamic Island (priorità bassa) e della card treno nell'app.

## Punti aperti
Vedi "Da verificare" in `decisioni.md` (V-02…V-07). Contatto per i titolari dei dati deciso (D-30): User-Agent e README.
