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
public struct API {
    
    
    public init(apiRoute: APIRoute) {
        self.apiRoute = apiRoute
    }
    
    ///Tutte le casistiche dei possibili percorsi del Server.
    ///
    ///
    ///
    public enum APIRoute {
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
        
        case hostReport
        case hostReportHistory
        
        case login
        case logout
        
        case students
        case appendStudent
        case updateStudent(String)
        case deleteStudent
        
        
        
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
           return "api/avaibility"
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
       case .hostReport:
           return "api/debug/hostreport"
       case .hostReportHistory:
           return "api/debug/hostreport-history"
       }
    }
    
    public var method: APIMethod {
        switch apiRoute {
        case .simulateError,.clearErrors,.clearError(_), .clearBotHistory, .clearAPIHistory,.login,.logout, .appendStudent, .updateStudent(_), .deleteStudent:
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
