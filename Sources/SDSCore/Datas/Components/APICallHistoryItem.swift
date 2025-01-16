//
//  APICallHistoryItem.swift
//  SDSCore
//
//  Created by Sese on 06/01/25.
//

import Foundation

///La struttura di dati che rappresenta, nell'app, una chiamata al Server.
///
///
///##
///La documentazione equivalente nel server si trova nel paragrafo <doc:Server###Cronologia-delle-chaimate-API>.
///
///
struct APICallHistoryItem: Codable {
    
    
    let timestamp: String
    let api: String
    let sessionID: String
    let method: String
    
    let body: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case api
        case sessionID = "session_id"
        case method
        case body
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.api = try container.decode(String.self, forKey: .api)
        self.sessionID = try container.decode(String.self, forKey: .sessionID)
        self.method = try container.decode(String.self, forKey: .method)
        self.body = try container.decodeIfPresent([String: String].self, forKey: .body)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.api, forKey: .api)
        try container.encode(self.sessionID, forKey: .sessionID)
        try container.encode(self.method, forKey: .method)
        try container.encodeIfPresent(self.body, forKey: .body)
    }
    
}
