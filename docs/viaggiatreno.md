# ViaggiaTreno: campi utili all'app

Riferimento per la gestione dei casi (ritardo, binario, soppressioni), anche quelli che la prova dal vivo potrebbe non mostrare.

Fonte: documentazione della community, https://github.com/dltmtt/viaggiatreno-api (README e cartella `schemas/`, ultimo aggiornamento agosto 2026). **Non è documentazione ufficiale di Trenitalia**: i campi sono stati confrontati con le risposte reali (sezione sotto). Qui ci sono solo i nomi e il significato dei campi, nessun dato di ViaggiaTreno (D-29).

## Confronto con le risposte reali (2026-11-02, ore 16:26)
Prova dal PC locale con 7 richieste (V-08). La documentazione corrisponde a quanto ricevuto, con queste precisazioni:
- **Ritardo nel tabellone**: per i treni già in viaggio coincide con quello dell'andamento (es. 6 minuti in entrambi). Per i treni non ancora partiti dall'origine è **vuoto**, non 0; in quel caso `nonPartito` vale `true`.
- **Fermate future nell'andamento**: `ritardoPartenza` e `ritardoArrivo` valgono 0 e `effettiva` è vuoto. Non sono una previsione: per le fermate non ancora raggiunte va usato il `ritardo` complessivo del treno.
- **`actualFermataType`**: vale 1 per le fermate già fatte e 0 per quelle future. La documentazione descrive solo 2 (straordinaria) e 3 (soppressa).
- **Orario della fermata**: nell'andamento, `programmata` di una fermata intermedia è l'arrivo, che può essere un minuto prima della partenza mostrata nel tabellone (Monza: 16:07 contro 16:08). Per la partenza va usato `partenza_teorica`.
- **`subTitle`**: vuoto (`""`) per i treni regolari.
- **Tabellone**: copre circa un'ora e mezza dall'ora richiesta, più i treni ancora in stazione. I treni già partiti non compaiono più, quindi l'app deve passare all'andamento del treno.
- **Ricerca per numero**: restituisce origine e data del treno nel formato `numero - DESTINAZIONE - gg/mm/aa|numero-codiceOrigine-millisecondi`.
- **Destinazione** in maiuscolo ("LECCO", "MILANO PORTA GARIBALDI"); in `orari.json` è "Lecco". Il collegamento tra le due fonti si fa sul numero del treno, non sul nome.
- Nessun treno soppresso o deviato al momento della prova: i campi delle soppressioni sono confermati solo nel caso regolare (`provvedimento` 0, `tipoTreno` PG).

## Endpoint previsti
Base: `http://www.viaggiatreno.it/infomobilita/resteasy/viaggiatreno/`
- `autocompletaStazione/{testo}`: nome e codice della stazione (formato `S` + 5 cifre, atteso uguale al GTFS: Monza `S01322`, Cernusco-Merate `S01513`).
- `partenze/{codiceStazione}/{data}`: tabellone delle partenze.
- `cercaNumeroTrenoTrenoAutocomplete/{numero}`: dal numero del treno ricava stazione di origine e data, che servono per `andamentoTreno`.
- `andamentoTreno/{codiceOrigine}/{numero}/{dataPartenzaInMillisecondi}`: stato completo del treno, fermata per fermata.

## Riconoscere un treno Trenord
- `codiceCliente` = `63` (Trenord). TILO è `64`, i regionali Trenitalia `2`.
- `numeroTreno`: numero intero, da confrontare con il numero dentro `trip_short_name` del GTFS (es. "RE_8 - 2855" → 2855).
- `categoria`: per i regionali atteso `REG`.

## Ritardo
- In `partenze`, `ritardo` (minuti, negativo se in anticipo) **è spesso 0 anche quando il treno è in ritardo**: la documentazione consiglia `andamentoTreno` come dato affidabile.
- In `andamentoTreno`: `ritardo` complessivo; per ogni fermata `ritardoPartenza` e `ritardoArrivo`, orari `partenza_teorica`/`partenzaReale` e `arrivo_teorico`/`arrivoReale`.
- `oraUltimoRilevamento` e `stazioneUltimoRilevamento`: ultima posizione nota del treno.
- `nonPartito`, `circolante`, `arrivato`: stato del treno.

## Binario (V-09)
- `binarioProgrammatoPartenzaDescrizione`: binario programmato.
- `binarioEffettivoPartenzaDescrizione`: binario effettivo, se assegnato (può essere vuoto finché non viene deciso).
- In `andamentoTreno` gli stessi campi ci sono per ogni fermata: per Monza si legge la fermata con codice `S01322`.

## Soppressioni e variazioni
Casi importanti per l'app anche se nella prova non si presentano.
- `provvedimento`: 0 = regolare, 1 = **soppresso del tutto**, 2 = soppresso nell'ultima parte (arriva in un'altra stazione), 3 = deviato (fermate soppresse o orari cambiati).
- `tipoTreno` (solo `andamentoTreno`):
  - `PG`: regolare;
  - `ST`: **soppresso**;
  - `SI`: soppresse le prime fermate;
  - `SF`: soppresse le ultime fermate;
  - `DV`: deviato;
  - `VO`: cambio di origine;
  - `VD`: cambio di destinazione;
  - `SM` e `PP`: significato incerto.
- Per ogni fermata: `actualFermataType` = 3 indica **fermata soppressa** e 2 fermata straordinaria; `tipoFermata` vuoto indica una fermata soppressa.
- `subTitle`: testo del provvedimento. Può essere `null`; secondo la documentazione il sito ufficiale va in errore in questo caso, quindi l'app deve gestirlo.
- `compRitardo`: testo pronto per la visualizzazione, per esempio "in orario" o "Cancellato".

Conseguenza per l'app: un treno vale **soppresso alla stazione di partenza dell'utente** se è soppresso del tutto (`provvedimento` 1 o `tipoTreno` ST), oppure se la fermata di partenza o di arrivo dell'utente risulta soppressa. Le soppressioni parziali che non toccano le fermate dell'utente non rendono il treno inutile.

## Campi da ignorare
Molti campi sono sempre vuoti o costanti, per esempio `statoTreno`, `fermateSoppresse`, `provvedimenti` e `anormalita` in `andamentoTreno`. Le soppressioni si leggono dai campi sopra, non da questi.
