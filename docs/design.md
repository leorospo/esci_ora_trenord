# Design

Stato: da produrre con Claude Design (su Windows). Per ora solo la Live Activity; le schermate di configurazione sono in Fase 2.

## Da progettare
Schermata di blocco e Dynamic Island (iPhone 16: Dynamic Island presente; priorità bassa rispetto alla schermata di blocco).

### Stati della card treno
1. **Tracciato in tempo reale**: "Esci tra XX minuti" in evidenza, orario di partenza previsto, ritardo.
2. **Nessun dato real time**: etichetta "Nessun dato real time per questo treno", card visivamente distinta (meno enfasi/indicatore di minore affidabilità); "Esci tra" calcolato sul programmato.
3. **Esci ora**: stile urgente quando il tempo è a zero o passato e il treno non è partito.
4. **Cancellato/soppresso**: resta visibile con stato chiaro.
5. **Dopo la partenza** (backlog di dettaglio): stato, ritardo, ETA stazione, ETA destinazione.

### Elementi globali
- Errore globale se il feed real-time è irraggiungibile.
- Indicatore "aggiornato alle HH:MM".
- Tasto "Termina".
- Una sola card quando resta un solo treno utile.
- Attribuzione fonte dati (nell'app, non necessariamente nella Live Activity).

## Principi
- Leggibilità a colpo d'occhio: l'informazione principale è "Esci tra XX minuti".
- Distinzione visiva fra dati tracciati e dati solo programmati, non affidata al solo colore.
- Nessuna interazione richiesta per vedere le informazioni.

## Esiti del design
Qui verranno registrati i link o gli export dei design prodotti e le decisioni su stile, colori e tipografia.
