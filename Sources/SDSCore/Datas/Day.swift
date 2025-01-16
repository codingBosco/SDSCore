//
//  Day.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Un insieme di 4 blocchi orari previsti dalla scuola, contente diversi pacchetti per ogni classe e blocco.
public struct Day: Identifiable, Codable {
    
    public var id: String
    
    ///La data del giorno
    public var date: Date
    
    ///Gli IDs dei pacchetti che si terranno in questo blocco orario
    public var packs: [String]
    
    public init(id: String, date: Date, packs: [String] = []) {
        self.id = id
        self.date = date
        self.packs = packs
    }
    
}
