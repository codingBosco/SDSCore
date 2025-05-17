//
//  Day.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Un insieme di 4 blocchi orari previsti dalla scuola, contente diversi pacchetti per ogni classe e blocco.
@Observable
public class Day: SDSEntity {
   
    public var id: String
    
    ///La data del giorno
    public var date: Date
    
    ///Gli IDs dei pacchetti che si terranno in questo blocco orario
    public var packs: [String]
    
    public init(id: String = UUID().uuidString, date: Date, packs: [String] = []) {
        self.id = id
        self.date = date
        self.packs = packs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case date = "date"
        case packs = "packs"
    }
    
    public required init(from decoder: any Decoder) throws {
        var ct = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try ct.decode(String.self, forKey: .id)
        
        let dateString = try ct.decode(String.self, forKey: .date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY hh-mm-ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let parsedDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: ct, debugDescription: "Formato data non valido: \(dateString)")
        }
        
        date = parsedDate
        
        packs = try ct.decode([String].self, forKey: .packs)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var ct = try encoder.container(keyedBy: CodingKeys.self)
        try ct.encode(id, forKey: .id)
        try ct.encode(date, forKey: .date)
        try ct.encode(packs, forKey: .packs)
    }
    
}

func convertToDate(from dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    formatter.locale = Locale(identifier: "it_IT") // o "en_US_POSIX" per sicurezza
    return formatter.date(from: dateString)
}
