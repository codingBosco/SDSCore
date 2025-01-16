//
//  ErrorHistoryItem.swift
//  SDSCore
//
//  Created by Sese on 06/01/25.
//

import Foundation

///Una struttura di dati che rappresenta un errore interno al server
///
///Per scoprire di più sulla gestione degli errori e i report vedi <doc:Server###Report-e-Cronologia-errori>
///
struct ErrorHistoryItem: Codable {
    let timestamp: String
    let apiRequest: String
    let localizedError: String
    let errorData: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case apiRequest = "function"
        case localizedError = "localizedErrorDescription"
        case errorData = "error"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.apiRequest = try container.decode(String.self, forKey: .apiRequest)
        self.localizedError = try container.decode(String.self, forKey: .localizedError)
        self.errorData = try container.decode([String : String].self, forKey: .errorData)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.apiRequest, forKey: .apiRequest)
        try container.encode(self.localizedError, forKey: .localizedError)
        try container.encode(self.errorData, forKey: .errorData)
    }
    
    
}
