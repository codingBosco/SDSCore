//
//  Block.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///La rappresentazione dell'utente che ha effettuato l'accesso all'app durante il primo avvio
public struct Profile: Codable {


    ///Il nome dell'utente autenticato
    public var username: String
    
    ///Il codice di sicurezza richiesto per accedere al Profilo.
    ///
    ///Il Codice di Sicurezza rappresenta la password dell'account a cui fate l'accesso.
    ///
    public var secureCode: String
    
    ///L'identificativo della sessione correttamente autenticata
    ///
    ///Ogni volta che si esegue un nuovo accesso da un nuovo dispositivo, si avvia una Sessione di Accesso. Ogni sessione ha un proprio identificativo univoco, gestito diversamente in basa alla piattaforma a cui ci si autentica
    ///
    ///
    ///- Nel _Bot Telegram_, nel _Web Portal_ e tramite richieste per riga di comando, come ad esempio _Postman_, il codice di sicurezza verrà generato dal Server sotto forma di una serie di 24 caratteri alfanumerici (a simboli esclusi), ad esempio `tgbGC9yzT8zwNaItXWJtorqm`.  I primi tre caratteri compongono un codice di riferimento che identifica l'ambiente della sessione. Scopri di più nella sezione <doc:Server###Codici-di-Riferimento-per-le-sessioni>.
    ///
    ///> Important: Se il codice viene generato dal server, questo richiederà una maggiore capacità di calcolo da parte della macchina che lo ospita. Assicurati di aver avviato il server su una macchina adatta. In caso contrario, alcune funzioni del server saranno limitate per il Bot Telegram, Il Web Portal e i Prompt da Riga di Comando. Vai a <doc:Server###Requisiti-minimi-e-Compatibilità-del-Server> per scoprire di più sulle limitazioni hardware.
    ///
    ///
    ///
    ///
    ///- Nell'applicazione _SDSKit_, Il codice sarà generato dal dispositivo sotto forma di codice di 32 caratteri alfanumerici e simboli inclusi, ad esempio: `UR299fEM8_0BulxL_O5H96naO_wchlTh` è un codice di accesso di una sessione sull'app per iOS.
    ///
    ///
    public var sessionID: String
    
    ///Un elenco delle sessioni attive nel profilo.
    public var activeSessions: [String]
    
    public init(username: String, secureCode: String, sessionID: String, activeSessions: [String]) {
        self.username = username
        self.secureCode = secureCode
        self.sessionID = sessionID
        self.activeSessions = activeSessions
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case secureCode
        case sessionID
        case activeSessions = "authorized_sessions"
    }
    
    public init(from decoder: any Decoder) throws {
        let ct = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try ct.decode(String.self, forKey: .username)
        self.secureCode = try ct.decode(String.self, forKey: .secureCode)
        self.activeSessions = try ct.decode([String].self, forKey: .activeSessions)
        
        self.sessionID = try ct.decode(String.self, forKey: .sessionID)
        
    }
    
    public func encode(to encoder: any Encoder) throws {
        var ct = encoder.container(keyedBy: CodingKeys.self)
        
        try ct.encode(username, forKey: .username)
        try ct.encode(secureCode, forKey: .secureCode)
        try ct.encode(activeSessions, forKey: .activeSessions)
        try ct.encode(sessionID, forKey: .sessionID)
    }
    
    
    
}
