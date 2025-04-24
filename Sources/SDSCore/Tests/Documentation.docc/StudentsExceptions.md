# Aggiungi le Eccezioni per adattare il planning alle esigenze degli studenti.

Gestisci assenze, uscite anticipate o Fuori Classe per ogni singolo studente e scopri come il planning si rimodula automaticamente a questi cambiamenti.


## Overview

Non si può dare per scontato che ogni studente sia presente nell'istituto dal primo al quarto blocco. Le cause che influenzano la presenza di uno studente nella mattinata possono essere varie: Esigenze personali, Entrata posticipata o uscita anticipata attraverso una circolare della segretria, l'uscita anticipata delle prime e seconde classi per due giorni alla settimana. Allo stesso tempo, è fondamentale conoscere la posizione di ogni studente e dunque gestire in maniera appropriata ogni eventuale assenza, temporanea o meno.

Per manetenere la gestione dei dati efficiente e le prestazioni del server e della connessione tra dispositivi stabili, si è scelto di utilizzare un sistema a **codici** per segnalare l'assenza di uno studente. 

### Struttura delle Eccezioni

Ogni eccezione è rappresentata da una struttura di dati specificia: ``StudentException``.
Tutte le eccezioni contengono informazioni basilari per essere comprese a pieno:
- ``StudentException/day``: è una Stringa, un testo, e corrisponde all'ID del giorno in cui l'eccezione è valida. 

### Capire i codici
