# Design

Stato: Live Activity della schermata di blocco progettata con Claude Design e rifinita con una sessione di grilling (2026-11-02, D-44…D-50). Valida per lo spike della Fase 0 e per l'MVP. Le schermate di configurazione sono in Fase 2.

## Riferimento visivo
- Design: https://claude.ai/code/artifact/5b40501d-c1cd-4cf2-be43-8452612d5aba, pagina "Schermata di blocco", tavole **Iter. 4 · 1–9** (chiaro e scuro).
- Componente di riferimento: `ActivityV4.dc.html`.
- Design system: esci_ora_ds; il tema scuro è derivato dai suoi token.
- In caso di dubbio prevale la tavola.

## Vincoli
- 361 pt di larghezza, altezza massima 160 pt. Le versioni A e B (circa 230–250 pt) sono scartate.
- Aspetto nativo iOS, chiaro e scuro (segue il sistema), stato non affidato al solo colore. Lingua italiana.
- Esempi di design con stazioni e linee reali (Monza → Cernusco Merate, S8): il design resta interno al progetto.
- Tipografia: Geist per gli orari, con cifre a larghezza fissa. Mono solo per i minuti di "Esci tra" e per il numero del treno.

## Struttura della Live Activity (schermata di blocco)
Nessun pulsante: la chiusura è il gesto standard di iOS (swipe da destra a sinistra). "Sono salito" non è nella Live Activity ma nella card treno dentro l'app.

Due card (treni) per volta; una sola quando resta un solo treno: identica alle altre, la Live Activity è solo più bassa.

### Card treno
Due colonne separate da un divisore tratteggiato.
- **Colonna sinistra, prima riga**: numero del treno · capolinea · durata del viaggio. Il capolinea si tronca con "…" in ogni stato; il nome completo è nell'app (D-45).
- **Colonna sinistra, seconda riga**: partenza → arrivo previsti, poi la pill di stato. Con ritardo compare solo l'orario aggiornato.
- **A destra della colonna sinistra**: il quadrato del binario (vedi *Binario*).
- **Colonna destra** (al massimo il 30% della card): "Esci tra" piccolo e leggero con sotto i minuti grandi e l'apostrofo ("12'"), oppure "Esci ora", oppure "Soppresso". "Esci tra" è un timer di sistema: scorre senza aggiornamenti dall'app.
- La stazione di destinazione non è sulla card: la tratta compare una volta sola nel piede.

### Pill di stato (D-46)
- Ritardo di almeno 2 minuti: pill arancione "+N min".
- In orario, ritardo sotto i 2 minuti, anticipo: nessuna pill, è lo stato normale.

### Binario (D-48)
Quadrato 28 × 28 pt: "BIN" piccolo sopra, numero sotto. Valore mostrato: binario effettivo, poi programmato, poi "–".
- **Programmato**: bordo sottile neutro. Stato di default.
- **Confermato**: solo quando il tempo reale dichiara il binario effettivo. Cerchio verde con spunta nell'angolo in alto a destra; verde di "in orario".
- **Cambio binario** (effettivo diverso dal programmato): quadrato arancione (bordo, sfondo tenue, numero) con il nuovo numero e spunta arancione nell'angolo. Tavole 8 e 9.
- **Su card "Esci ora"**: gli stessi segnali invertiti, bianco su arancione (in scuro nero su arancione).
- **Nessun quadrato**: card senza real time, treno soppresso.
- **Dopo la partenza**: nei 5 minuti prima che la card esca (D-41) il quadrato resta com'è.
- VoiceOver: "binario N confermato", "binario N programmato", "binario cambiato: 6, era 4".

### Bus sostitutivo (D-50)
- Il numero diventa "BUS 98102" preceduto dall'icona bus frontale piena (12 pt). L'icona resta anche se ripete il quadrato: caso raro, l'impatto si valuta sul telefono.
- Al posto del binario, lo stesso quadrato con bordo contiene l'icona bus e la scritta "BUS". VoiceOver: "bus sostitutivo".
- Si combina con gli altri stati; caso di riferimento: una card "Esci ora" e una senza real time (tavola 7).

### Piede
- Una riga: tratta a sinistra ("Monza → Cernusco Merate"), "Aggiornato alle HH:MM" a destra.
- In caso di errore globale la riga è sostituita da "⚠ Tempo reale non raggiungibile · agg. HH:MM" in arancione (la tratta non si vede).

## Stati della card
| Stato | Aspetto | Colonna destra |
|---|---|---|
| Tempo reale | card piena neutra; pill solo con ritardo ≥ 2 min | Esci tra N' |
| Esci ora | card arancione piena, testo bianco; resta fino all'uscita della card, 5 minuti dopo la partenza (D-41) | Esci ora |
| Senza real time | card senza riempimento, bordo tratteggiato 10/6, icona e "Senza real time" al posto della pill, nessun binario; minuti uguali alle altre card, senza tilde (D-47). La frase completa "Nessun dato real time per questo treno" sta nella card dell'app | Esci tra N' |
| Soppresso | card rossa tenue, orari barrati, senza binario; visibile fino all'orario programmato (D-42) | icona × + "Soppresso" |
| Errore globale | nessuna etichetta per treno ("Senza real time" vale solo per i singoli treni non tracciati); piede di errore in arancione (D-49) | Esci tra N' |

## Principi
- Leggibilità a colpo d'occhio: l'informazione principale è "Esci tra".
- Distinzione visiva fra dati tracciati e dati solo programmati, non affidata al solo colore.
- Nessuna interazione necessaria per vedere le informazioni.

## Da progettare
- Vista "in viaggio" dopo "Sono salito su questo treno" (Fase 3) (arrivo previsto, ritardo, ETA). L'azione "Sono salito" esiste solo nell'app.
- Dynamic Island (compatta, minimale, espansa), priorità bassa.
- Card treno nell'app con "Sono salito" e frase completa per i treni senza real time (con le schermate dell'app).
- Schermate di configurazione (Fase 2).
