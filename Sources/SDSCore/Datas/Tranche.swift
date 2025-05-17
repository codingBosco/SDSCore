//
//  File.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Una serie di giorni in sequenza che offrono diversi pacchetti di conferenze
@Observable
public final class Tranche: SDSEntity {
    
    public var id: String
    
    ///Un nome, formale, dato alla tranche
    public var formal: String
    
    public var date: Date //solo mese e anno
    
    ///Gli IDs dei giorni nei quali si svolge la Tranche. Ogni giorno ha una propria data e i relativi riferimenti in IDs dei pacchetti disponibili.
    public var days: [String]
    
    ///Il numero, restituito come intero (Int), dei giorni della tranche
    public var daysNum: Int {
        days.count
    }
    
    public init(id: String = UUID().uuidString, formal: String, date: Date, days: [String]) {
        self.id = id
        self.formal = formal
        self.date = date
        self.days = days
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Tranche, rhs: Tranche) -> Bool {
        lhs.formal == rhs.formal
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case formal
        case date
        case days
    }
    
    public func encode(to encoder: any Encoder) throws {
        var ct = encoder.container(keyedBy: CodingKeys.self)
        
        try ct.encode(id, forKey: .id)
        try ct.encode(formal, forKey: .formal)
        try ct.encode(date, forKey: .date)
        try ct.encode(days, forKey: .days)
        
    }
    
    public init(from decoder: any Decoder) throws {
        let ct = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try ct.decode(String.self, forKey: .id)
        formal = try ct.decode(String.self, forKey: .formal)
        
        let dateString = try ct.decode(String.self, forKey: .date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY hh-mm-ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let parsedDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: ct, debugDescription: "Formato data non valido: \(dateString)")
        }
        
        date = parsedDate
        days = try ct.decode([String].self, forKey: .days)
        
    }
    
}

extension Tranche {
    
    public static var newTranche: Tranche {
        return Tranche(formal: "", date: Date(), days: [])
    }
    
}
