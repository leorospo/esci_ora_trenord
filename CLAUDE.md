# CLAUDE.md — Istruzioni per Claude Code

Progetto: app iOS personale con Live Activity per i prossimi treni Trenord nel tragitto casa-lavoro.
Lingua di lavoro con l'utente: italiano. Nomi di codice e commenti tecnici possono essere in inglese.

## Chi è l'utente e come lavorare con lui
- Leonardo è UX/UI designer e sviluppatore frontend. **Non conosce Swift e non intende impararlo**: il codice è interamente delegato a te.
- Non vuole vedere codice se non necessario. Comunica con riassunti in italiano: cosa hai fatto, cosa cambia per lui, cosa deve approvare.
- Prima di ogni fase o cambio rilevante presenta una overview breve e attendi la sua approvazione.
- Account Apple **gratuito**: nessun Apple Developer Program a pagamento, quindi niente notifiche push APNs né TestFlight. Side loading con firma che scade ogni 7 giorni.
- Il progetto parte su Windows. **Quando un passaggio richiede il Mac (compilazione con Xcode, installazione sul telefono) chiedi all'utente se lo ha a disposizione prima di procedere.**

## Fonte di verità
Il repository è l'unica fonte di verità. All'inizio di ogni sessione leggi, in quest'ordine:
1. `docs/stato.md` (fase corrente, prossimi passi, punti aperti)
2. `docs/requisiti.md`
3. `docs/decisioni.md`
4. `docs/design.md`
5. `docs/backlog.md`

## Regole di allineamento (obbligatorie)
1. Nessuna modifica a requisiti, design o codice senza aggiornare nello stesso passaggio il documento corrispondente.
2. Ogni decisione nuova o cambiata va aggiunta a `docs/decisioni.md` con data, motivo e, se ne sostituisce una precedente, il riferimento a quella.
3. Ogni sessione si chiude aggiornando `docs/stato.md`.
4. Se un requisito risulta irrealizzabile o in conflitto con un'altra decisione, **fermati e segnalalo all'utente**; non scegliere in silenzio.
5. Le funzioni che usano la posizione come dato (non solo come mezzo per restare attivi in background) vanno in `docs/backlog.md`.
6. Fatti sull'ambiente (API, limiti di iOS, formati dei feed) vanno verificati sulle fonti ufficiali, non assunti; annota la fonte in `docs/decisioni.md`.

## Vincoli tecnici noti
- Una Live Activity può essere avviata solo con l'app in primo piano, oppure programmata su iOS 26 con `Activity.request(... start:)` (programmazione fatta con app in primo piano). Da verificare in Fase 0.
- Senza push gli aggiornamenti in background non sono garantiti: si usa la posizione in background, con precisione minima, solo per tenere vivo il processo durante la finestra di monitoraggio.
- Dispositivo di riferimento: iPhone 16, iOS 26.5.2.
- Licenza dati: GTFS Trenord CC-BY 4.0; l'app deve riportare l'attribuzione.

## Struttura prevista del repository
```
CLAUDE.md
docs/
  stato.md
  requisiti.md
  decisioni.md
  design.md
  backlog.md
```
Le cartelle di codice (app iOS) e della pipeline dati verranno aggiunte e descritte qui.
