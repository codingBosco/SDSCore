//
//  File.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Un insieme di conferenze a cui qualsiasi studente (entro il limite massimo) può iscriversi e partecipare.
public struct Pack: SDSEntity {
    
    public var id: String
    
    public var formal: String
    
    ///L'id della classe nella quale si terrà il pacchetto e le relative conferenze.
    public var classe: String
    
    
    ///Gli IDs delle conferenze disponibili per il pacchetto
    public var conferences: [String]
    
    ///Il giorno in cui si svolgerà il pacchetto, sottoforma di ID del giorno
    public var day: String
    
    public init(id: String = UUID().uuidString, formal: String, classe: String, conferences: [String], day: String) {
        self.id = id
        self.formal = formal
        self.classe = classe
        self.conferences = conferences
        self.day = day
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.formal, forKey: .formal)
        try container.encode(self.classe, forKey: .classe)
        try container.encode(self.conferences, forKey: .conferences)
        try container.encode(self.day, forKey: .day)
    }
    
    public enum CodingKeys: CodingKey {
        case id
        case formal
        case classe
        case conferences
        case day
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.formal = try container.decode(String.self, forKey: .formal)
        self.classe = try container.decode(String.self, forKey: .classe)
        self.conferences = try container.decode([String].self, forKey: .conferences)
        self.day = try container.decode(String.self, forKey: .day)
    }
    
}
