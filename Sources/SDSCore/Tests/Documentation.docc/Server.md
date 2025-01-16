# Server

Scopri di più sul server che sta dietro alla macchina organizzativa della SDS, imparando ad utilizzare, gestire e ottimizzare ciò che rende disponibile il database a tutti.

## Overview

Il Server è il cuore pulsante dell'organizzazione della Settimana dello Studente. Permette di accedere al Database condiviso, sempre disponibile e modificare da chi ne ha accesso. 

In questo articolo vi saranno informazioni utili su come funziona il tutto, dai primi passi nel codice fino al Debug e alla risoluzione di problemi

## La Struttura

## Autenticazione e Sicurezza


### Crea un nuovo profilo di accesso
Per aumentare la sicurezza del Server e prevenire accessi indesiderati, la procedura di creazione di un nuovo account si può effettuare esclusivamente dal terminale della macchina che sta ospitando il Server stesso. 

Ad esempio, se per una prova, si avvia il server da un Computer fisso, per creare un nuovo account sarà necessario avviare il Terminale (o Prompt dei Comandi PowerShell), del Computer fisso e, attraverso riga di comandi.

### Codici di Riferimento per le sessioni
Una volta effettuato l'accesso al profilo, il Server aggiungerà l'ID della sessione nella lista apposita. (Vai a <doc:Profile/sessionID> per l'app e <doc:Server##API-di-Login> per il Server.)

## Gestione dei Dati

## Elenco API
Il server 

### Percorso principale
ddddejdjwiqjdiqjwiodjqiwdjiqw
wqdwqhdioqwj


### Stato del server
Puoi richiedere l'attuale disponibilità del server e relative informazioni eseguendo la richiesta `GET` al percorso 
```html
http://<ip>:<port>/api/avaibility
```

Una volta effettuata la richiesta, verrà richiamata la funzione 
```javascript
app.get('/api/avaibility', (req, res) => { ... } )
```

> Alias nell'App: Scopri di più sulla chiamata di questa funzione nell'app in <doc:API/APIRoute-swift.enum/avaibility>

> Alias nel Bot Telegram: Scopri di più sulla chiamata di questa funzione nel bot telegram in <doc:Bot###Stato-del-Server>

### API di Login

## Debug e Risoluzione dei Problemi

### Requisiti minimi e Compatibilità del Server


### Report e Cronologia errori
In caso si verifichino errori nel codice del Server o si inseriscano strutture di dati 


