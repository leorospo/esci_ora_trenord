# Design

Stato: Live Activity progettata con Claude Design (versione C scelta, 156 pt). Da registrare qui il link o l'export dei design quando l'utente li fornisce. Le schermate di configurazione sono in Fase 2.

## Vincoli
- Altezza massima della Live Activity sulla schermata di blocco: 160 pt. La versione scelta (C) sta a 156 pt. Le versioni A e B (circa 230–250 pt) sono scartate.
- Aspetto nativo iOS, chiaro e scuro, stato non affidato al solo colore.
- Esempi di design con stazioni e linee reali (Monza → Cernusco Merate, S8): il design resta interno al progetto.
- Tipografia: Geist per gli orari, con cifre a larghezza fissa. Mono solo per i minuti di "Esci tra" e per il numero del treno.

## Struttura della Live Activity (schermata di blocco)
Nessun pulsante: la chiusura è il gesto standard di iOS (swipe da destra a sinistra). "Sono salito" non è nella Live Activity ma nella card treno dentro l'app.

### Card treno (fino a 2)
- **Prima riga**: numero del treno (es. "S8 98102") e durata del viaggio (es. "23 min").
- **Riga centrale**: partenza → arrivo previsti (es. "08:02 → 08:25"). In caso di ritardo compare solo l'orario aggiornato, senza l'orario programmato originale.
- **Stato**: etichetta sempre visibile: "In orario", "+4 min", "Senza real time".
- **Colonna destra** (larga al massimo il 30% della card): "Esci tra" piccolo e leggero, sotto il numero grande con apostrofo (es. "12'").
- La stazione di destinazione non è sulla card: la tratta compare una volta sola nel piede.

### Piede
- Una riga: tratta a sinistra (es. "Monza → Cernusco Merate"), "Aggiornato alle HH:MM" a destra.
- In caso di errore globale la riga è sostituita da: "⚠ Tempo reale non raggiungibile · agg. 07:31" (la tratta non si vede).

## Stati
1. **Tracciato in tempo reale**: card standard, stato "In orario" o "+N min".
2. **Senza dati real time**: etichetta breve "Senza real time" con icona, bordo tratteggiato a tratti lunghi, "~" davanti ai minuti. La frase completa "Nessun dato real time per questo treno" sta nella card dell'app.
3. **Esci ora**: la colonna destra mostra "Esci ora", card arancio piena (testo rifinito dall'utente nel design).
4. **Soppresso**: nella colonna destra icona × con sotto "Soppresso"; orari barrati.
5. **Errore globale**: vedi piede.
6. **Una sola card**: identica alle altre; la Live Activity è semplicemente più bassa.
7. **Dopo la partenza** (dettaglio da definire): stato, ritardo, ETA stazione, ETA destinazione.

## Principi
- Leggibilità a colpo d'occhio: l'informazione principale è "Esci tra".
- Distinzione visiva fra dati tracciati e dati solo programmati, non affidata al solo colore.
- Nessuna interazione necessaria per vedere le informazioni.

## Da progettare
- Dynamic Island (compatta, minimale, espansa), priorità bassa.
- Card treno nell'app con "Sono salito" e frase completa per i treni senza real time (con le schermate dell'app).
- Schermate di configurazione (Fase 2).

## Esiti del design
Link o export dei design: da aggiungere.
