//
//  File.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Una serie di giorni in sequenza che offrono diversi pacchetti di conferenze
public struct Tranche: Identifiable, Codable {
    
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
    
    init(id: String = UUID().uuidString, formal: String, date: Date, days: [String]) {
        self.id = id
        self.formal = formal
        self.date = date
        self.days = days
    }
    
}
