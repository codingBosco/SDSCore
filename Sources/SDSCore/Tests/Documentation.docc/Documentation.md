# ``SDSCore``

Gestisci e Organizza nei minimi dettagli i giorni della Settimana dello Studente con questo framework realizzato per i dispositivi Apple.

## Overview

La Settimana Dello Studente ha sempre richiesto da parte della lista un quantitativo di impegno e sforzo non indifferenti. In un solo giorno sono previste più di 200 conferenze e fino a più di 30 conferenze simulatenee per blocco orario. Gli studenti devono riuscire nel modo più semplice e veloce possibile a raggiungere la classe dove si terranno le conferenze scelte e il tutto deve avvenire in totale ordine e sicurezza. 

Per gli organizzatori, ricevere le richieste di iscrizione, smistare gli studenti nelle classi, programmare i pacchetti e le conferenze per ogni blocco e classe, indirizzare gli ospiti al loro arrivo e riuscire a fornire la posizione esatta di ogni studente della scuola e in entrambi i plessi non è di certo semplice. È qui che il Framework, in sinergia con il <doc:Server>, il <doc:WebPortal>, il <doc:Bot> e la <doc:SDSKit-App> riesce a coordinare la complessa macchina della SDS in modo più efficiente e veloce.


### Capire come sono organizzati i dati
Ogni tipo di dato contiene una properità essenziale: *l'ID*: un identificativo univoco che rappresenta l'entità. Utilizzando gli ID, per eseguire dei confronti tra i dati o collegare due strutture di dati diversi tra loro risulta più semplice ed efficiente.

Ad esempio, la struttura dati dei Pacchetti: ``Pack``, è dotata di una proprietà: ``Pack/day``, che indica il giorno in cui è stato organizzato il pacchetto. Grazie all'utilizzo degli IDs, il giorno del pacchetto è rappresentato dall'ID del giorno presente sul database, ovvero ``Day``.``Day/id``. In questo modo, le dimensioni del Database rimangono contenute in quando ogni volta che vi è una connessione di questo tipo fra più strutture, esse condividono soltanto una o più stringhe. Inoltre, questo permette di evitare che, per connettere due strutture, come nel caso dei Pacchetti e dei Giorni, si debba duplicare il Giorno per renderlo disponibile sia nel database come entità singola, sia come riferimenti all'interno della struttura del Pacchetto. 

#### Capire come viene effettuata la ricerca tra dati
Dal momento che l'app e il Framework sono stati concepiti per dispositivi Apple, è stato possibile lasciare ad essi tutto il lavoro di filtraggio e ricerca per ogni volta che è presenta una connessione tra dati. 

Prendiamo come esempio la vista Studente: nella schermata riusciamo a vedere le informazioni dello studente come nome e il cognome. Riusciamo a vedere anche la classe che lo studente frequenta. In questo caso, nella struttura ``Student``, vi è la proprietà ``Student/classe``, rappresentata come l'ID della classe che lo studente frequenta. Lasciando però che la vista dello Studente mostri il valore della classe così come è non ci offre informazioni utili a capire, ad esempio, la sezione o il numero dell'aula. In questo caso, il dispositivo che mostra i dettagli dello Studente si occupa di tenere in memoria l'ID della classe (nella variabile ``Student/classe``), prendere l'intera collezione di classi dal database e vedere quali tra queste classi ha l'identificativo uguale a quello preso in considerazione. Nonostante la grande quantità di dati che sono disponibili, l'efficienza e le alte prestazioni dei chip Apple permettono di eseguire questa ricerca nell'immediato, senza influenzare sulle presentazioni del dispositivo. In questo modo, il Server rimane libero per accettare le nuove richieste da altri dispositivi e gestire il flusso di lavoro in maniera più efficiente.



## Topics

### Connessioni
Scopri nuovi modi per accedere e condividere i dati della SDS.
- <doc:SDSMicroGarden>
- <doc:Bot>


### Gestione degli Studenti
Impara a sfruttare tutte le funzioni a disposizione per gestire al meglio gli studenti.
- <doc:StudentsExceptions>

### Gestione dei Pacchetti
Organizza i pacchetti e scopri come il Planning si adatta ad ogni cambiamento.
- <doc:PacksBehaviours>
