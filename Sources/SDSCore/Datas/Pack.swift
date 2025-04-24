//
//  File.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Un insieme di conferenze a cui qualsiasi studente (entro il limite massimo) può iscriversi e partecipare.
@Observable
public class Pack: SDSEntity {
    
    // Ensure Codable conformance
    public var id: String
    public var formal: String
    public var classe: String
    public var conferences: [String]
    public var arguments: [String]
    public var day: String

    public init(id: String = UUID().uuidString, formal: String, classe: String, conferences: [String], arguments: [String], day: String) {
        self.id = id
        self.formal = formal
        self.classe = classe
        self.conferences = conferences
        self.arguments = arguments
        self.day = day
    }

    // Encoding is likely fine as is
    public func encode(to encoder: any Encoder) throws {
        var ct = encoder.container(keyedBy: CodingKeys.self)
        try ct.encode(self.id, forKey: .id)
        try ct.encode(self.formal, forKey: .formal)
        try ct.encode(self.classe, forKey: .classe)
        try ct.encode(self.conferences, forKey: .conferences)
        try ct.encode(self.arguments, forKey: .arguments)
        try ct.encode(self.day, forKey: .day)
    }

    public enum CodingKeys: String, CodingKey {
        case id
        case formal
        case classe = "classroom"
        case conferences
        case arguments
        case day
    }

    // Decoding is likely fine as is, but make sure you're using FirestoreDataDecoder
    required public init(from decoder: any Decoder) throws {
        let ct = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try ct.decode(String.self, forKey: .id)
        self.formal = try ct.decode(String.self, forKey: .formal)
        self.classe = try ct.decode(String.self, forKey: .classe)
        self.conferences = try ct.decode([String].self, forKey: .conferences)
        self.arguments = try ct.decode([String].self, forKey: .arguments)
        self.day = try ct.decode(String.self, forKey: .day)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Pack, rhs: Pack) -> Bool {
        lhs.formal == rhs.formal
    }
    
}


extension Pack {
    
    public static var newPack: Pack {
        return Pack(formal: "", classe: "", conferences: [], arguments: [], day: "")
    }
    
}
