# Pipeline orari (GTFS statico)

Ogni notte GitHub Actions (`.github/workflows/orari.yml`) scarica il GTFS Trenord, esegue i test e pubblica `orari.json` su GitHub Pages. Se un passo fallisce, resta online il file della notte precedente e GitHub segnala l'errore via email.

- `config.json`: codici GTFS delle stazioni. La pipeline calcola tutte le coppie in entrambi i versi.
- `build.py`: riduzione del feed (solo libreria standard di Python).
- `tests/`: test su un mini-feed. Si eseguono con `python -m unittest discover -s pipeline/tests`.

## Formato di `orari.json` (versione 1)
- `versione`, `generato` (UTC), `attribuzione` (da mostrare nell'app), `valido_dal`/`valido_al`.
- `stazioni`: codice → nome.
- `tratte`: una per coppia `da` → `a`, con `corse` ordinate per partenza. Ogni corsa contiene:
  - `treno`: numero, o codice per i bus;
  - `linea`: es. S8, RE8, oppure "Bus";
  - `mezzo`: `treno` | `bus`;
  - `partenza` dalla stazione `da` e `arrivo` alla stazione `a`, in formato `HH:MM`. Dopo mezzanotte l'ora può superare 24:00 (convenzione GTFS: ore dall'inizio della giornata di servizio);
  - `capolinea`: ultima fermata della corsa;
  - `giorni`: indice in `calendari`.
- `calendari`: liste di date (`AAAA-MM-GG`), da oggi in poi.
- Solo corse dirette (D-35). Le corse uguali su periodi diversi del feed sono unite.

Il file contiene solo orari programmati, mai dati di ViaggiaTreno (D-29).
