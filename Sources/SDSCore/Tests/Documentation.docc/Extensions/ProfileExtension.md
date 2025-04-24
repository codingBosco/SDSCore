# ``SDSCore/Profile``


## Perchè utilizzare i Profili?

Per un fattore di sicurezza, i percorsi e le API del server sono protetti da un prima barriera. I percorsi che restituiscono una serie di dati sensibili, ad esempio ottenere i dati di uno studente o eliminare un pacchetto dal Database, richiedono necessariamente che l'utente che effettua le richieste sia correttamente autenticato. 

### Prima di accedere all'app
Per poter autenticarsi nell'applicazione, sarà necessario creare un nuovo profilo di accesso. Per motivi di sicurezza, questa procedure può essere eseguita dal terminale del server. Per maggiori informazioni sulla creazione di un nuovo profilo, vai <doc:Server###Crea-un-nuovo-profilo-di-accesso>

### Login & Autenticazione


Nel codice sorgente del server, la chiamata API per effettuare il login è la seguente:

```js
app.post('/api/login', async (req, res) => { ... } )
```

La stringa ``api/login``
è il percorso del server che permette all'utente di autenticarsi.


Scopri di più nelle informazioni sul <doc:Server>


## Topics

### 

