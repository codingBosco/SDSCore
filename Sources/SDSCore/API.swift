//
//  API.swift
//  SDSCore
//
//  Created by Sese on 16/01/25.
//

import Foundation

///Una raccolta di regole e percorsi predefiniti tradotti dal Server all'App.
///
///Le funzioni dell'applicazione che richiedono l'operato del Server sono molteplici.
///
public struct API: Sendable {
    
    
    public init(apiRoute: APIRoute) {
        self.apiRoute = apiRoute
    }
    
    ///Tutte le casistiche dei possibili percorsi del Server.
    ///
    ///
    ///
    public enum APIRoute : Sendable{
        ///Il percorso predefinito del Server.
        ///
        ///## Alias del Server
        ///Puoi trovare la funzione che viene richiamata una volta effettuata la richiesta HTTP dall'app nella sezione <doc:Server###Percorso-principale>
        case main
        
        ///La risposta di disponibilità del Server.
        ///
        ///## Alias del Server
        ///Puoi trovare la funzione che viene richiamata una volta effettuata la richiesta HTTP dall'app nella sezione <doc:Server###Stato-del-server>
        case avaibility
        
        ///Controlla se la sessione corrente è autenticata o meno.
        ///
        ///## Alias del Server
        ///La funzione corrispondente al percorso ``checkAuth`` è
        ///```javascript
        ///app.get('/api/check-auth', (req,res) => { ... })
        ///```
        ///
        ///## Topics
        ///- ``API/route``
        ///- ``API/method``
        case checkAuth
        
        case debug
        case simulateError
        case clearBotHistory
        case clearAPIHistory
        case clearError(String)
        case clearErrors
        
        //MARK: PROFILE
        case login
        case logout
        
        //MARK: DATAS
        case students
        case appendStudent
        case updateStudent(String)
        case deleteStudent
        
        case classes
        case appendClass
        case updateClass(String)
        case deleteClass(String)
        
        case tranches
        case appendTranche
        case updateTranche(String)
        case deleteTranche(String)
        
        ///Restituisce tutti i giorni
        case days
        
        ///Aggiunge un nuovo giorno alla tranche specificata
        case appendDayInTranche(String)
        
        ///Restituisce i giorni delle tranche specificata
        case daysInTranche(String)
        
        ///Aggiorna i dati del giorno specificato
        case updateDay(String)
        ///Rimuove il giorno specificato
        case deleteDay(String)
        
        case packs
        case appendPack
        case updatePack(String)
        case deletePack(String)
        
        case conferences
        case appendConference
        case updateConference(String)
        case deleteConference(String)
        
        //MARK: DIAGNOSTICS
        
        case generateDiagnosticFile
        case diagnosticFiles
        case removeDiagnosticFiles
        case diagnosticFile(String)
        case removeDiagnosticFile(String)
        
        
    }
    
    public enum APIMethod: String {
        
        case post = "POST"
        case get = "GET"
    }

    
    public var apiRoute: APIRoute
    
    public var route: String {
       switch apiRoute {
       case .main:
           return ""
       case .avaibility:
           return "api/availability"
       case .checkAuth:
           return "api/check_auth"
       case .debug:
           return "api/debug"
       case .simulateError:
           return "api/debug/simulate_error"
       case .clearBotHistory:
           return "api/debug/clear_bot_history"
       case .clearAPIHistory:
           return "api/debug/clear_api_history"
       case .clearError(let errorPath):
           return "api/debug/clear_error/\(errorPath)"
       case .clearErrors:
           return "api/debug/clear_errors"
       case .login:
           return "api/login"
       case .logout:
           return "api/logout"
           
       case .students:
           return "data/students"
       case .appendStudent:
           return "data/students/append"
       case .updateStudent(let studentID):
           return "data/students/update/\(studentID)"
       case .deleteStudent:
           return "data/students/remove"
           
           
       case .classes:
           return "data/classrooms/"
       case .appendClass:
           return "data/classrooms/append"
           //TODO: Aggiungere qui
       case .deleteClass(_):
           return ""
       case .updateClass(_):
           return ""
           
       case .generateDiagnosticFile:
           return "api/diagnostics/generate"
       case .diagnosticFiles:
           return "api/diagnostics/files"
       case .removeDiagnosticFiles:
           return "api/diagnostics/files/removeAll"
       case .diagnosticFile(let fileID):
           return "api/diagnostics/files/\(fileID)"
       case .removeDiagnosticFile(let fileID):
           return "api/diagnostics/files/remove/\(fileID)"
           
       case .tranches:
           return "data/tranches/"
       case .appendTranche:
           return "data/tranches/append"
       case .updateTranche(let trancheID):
           return "data/tranches/update/\(trancheID)"
       case .deleteTranche(let trancheID):
           return "data/tranches/remove/\(trancheID)"
           
       case .days:
           return "data/days/"
       case .daysInTranche(let trancheID):
           return "data/days/inTranche=\(trancheID)/"
       case .appendDayInTranche(let trancheID):
           return "data/days/inTranche=\(trancheID)/append"
       case .updateDay(let dayID):
           return "data/days/update/\(dayID)"
       case .deleteDay(let dayID):
           return "data/days/remove/\(dayID)"
           
           
       case .packs:
           return "data/packs/"
       case .appendPack:
           return "data/packs/append"
       case .updatePack(let packID):
           return "data/packs/update/\(packID)"
       case .deletePack(let packID):
           return "data/packs/remove/\(packID)"
           
           
       case .conferences:
           return "data/conferences/"
       case .appendConference:
           return "data/conferences/append"
       case .updateConference(let conferenceID):
           return "data/conferences/update\(conferenceID)"
       case .deleteConference(let conferenceID):
           return "data/conferences/remove/\(conferenceID)"
       }
    }
    
    public var method: APIMethod {
        switch apiRoute {
        case .simulateError,.clearErrors,
                .clearError(_), .clearBotHistory, .clearAPIHistory,.login,.logout,
                .appendStudent,.updateStudent(_), .deleteStudent,
                .appendClass, .updateClass(_), .deleteClass(_),
                .appendPack, .updatePack(_), .deletePack(_),
                .appendConference, .updateConference(_), .deleteConference(_),
                .appendDayInTranche(_), .deleteDay(_), .updateDay(_),
                .appendTranche, .deleteTranche(_), .updateTranche(_):
            return .post
        default:
            return .get
        }
    }

    
}

extension API {
    @MainActor public static func routeTo(_ route: API.APIRoute) -> API {
        API.init(apiRoute: route)
    }
}
