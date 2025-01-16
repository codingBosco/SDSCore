//
//  InteractionHistoryItem.swift
//  SDSCore
//
//  Created by Sese on 06/01/25.
//

import Foundation

struct InteractionHistoryItem: Codable {
    
    let timestamp: Date
    let chatID: String
    let user: String
    let request: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case chatID = "chat_id"
        case user = "username"
        case request = "command"
        case message
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.chatID = try container.decode(String.self, forKey: .chatID)
        self.user = try container.decode(String.self, forKey: .user)
        self.request = try container.decode(String.self, forKey: .request)
        self.message = try container.decode(String.self, forKey: .message)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.chatID, forKey: .chatID)
        try container.encode(self.user, forKey: .user)
        try container.encode(self.request, forKey: .request)
        try container.encode(self.message, forKey: .message)
    }
    
}
