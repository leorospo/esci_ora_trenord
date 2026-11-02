# Stato del progetto

Ultimo aggiornamento: 2026-11-02

## Fase corrente
Pre-Fase 0. Fonte del tempo reale decisa (D-29). Nessun codice ancora scritto.

## Fatto
- Discussione di requisiti e architettura completata e approvata (vedi `decisioni.md`, D-01…D-20).
- Documenti iniziali del repository scritti.
- Design della Live Activity (schermata di blocco) fatto con Claude Design: versione C scelta, 156 pt. Modifiche registrate in D-21…D-28 e in `design.md`.
- Verifica V-01 (2026-10-31): l'API real-time Trenord sta solo dentro E015. Letti policy Trenord, contratto di adesione e Linee guida App (Allegato 1). E015 richiede approvazione discrezionale di Trenord, un server "App Broker" con certificati e la verifica del TMB: troppo lungo per un progetto da chiudere in pochi giorni. L'utente si è registrato a E015 ma **non ha inviato la richiesta né firmato il contratto**. La bozza di richiesta resta in `docs/richiesta-e015.md` come riferimento.
- Nessun feed real-time Trenord aperto trovato. Scelta ViaggiaTreno (API non ufficiale di Trenitalia) per uso personale, con i vincoli delle note legali (D-29, `requisiti.md`).
- La pipeline del GTFS statico, l'app e la verifica di ViaggiaTreno si possono fare in parte senza Mac.
- Prototipo "senza tempo reale" (2026-11-02, branch `claude/prototipo-senza-tempo-reale`): il tempo reale resta nell'MVP, con ripiego sugli orari programmati se non si riesce a collegarlo (D-31).

## Promemoria per l'utente
- **Sul PC dove hai usato Claude Code in locale (sessioni del 2026-11-01 e precedenti)**: rendi disponibile in cloud almeno la chat principale, quella dei prossimi passi. Le sessioni locali non si vedono su claude.ai/code. Il modo più semplice: in quella chat chiedi a Claude di riassumere le decisioni ancora non registrate nei documenti di `docs/` e di committarle; oppure avviala con Remote Control (`claude remote-control`) per vederla dal web. Poi cancella questa nota.

## Prossimi passi
**Prossima sessione (lunedì 2026-11-02): pipeline del GTFS statico (punto 2), con overview da approvare prima.** Le email di richiesta a Trenord (via TMB E015) e a Trenitalia sono state inviate dall'utente il 2026-11-01: in attesa di risposta. Valutate e scartate come alternative le documentazioni non ufficiali di ViaggiaTreno (Home Assistant, railway-opendata di Marco Aceti): usano lo stesso endpoint bloccato e risalgono al 2023 circa; utili solo come riferimento sul formato dei dati se arriva un permesso.

1. Prova tecnica di ViaggiaTreno (V-08) fatta il 2026-10-31: accesso negato dalla protezione anti-bot (403). D-29 non realizzabile così com'è. Il ritardo è irrinunciabile per l'MVP (utente, 2026-11-01). Bozze delle richieste di permesso a Trenord (via TMB E015) e a Trenitalia in `docs/richieste-permesso.md`, da inviare a cura dell'utente; basta una risposta positiva.
2. Pipeline del GTFS statico (GitHub Actions + Pages): overview da approvare prima.
3. Aggiungere in `design.md` il link o l'export dei design.
4. Quando il Mac è disponibile (Claude deve chiederlo): Fase 0 sul suo iPhone 16.
5. Eventuale design della Dynamic Island (priorità bassa) e della card treno nell'app.

## Punti aperti
Vedi "Da verificare" in `decisioni.md` (V-02…V-08). Contatto per i titolari dei dati deciso (D-30): User-Agent e README.
