//
//  File.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Un insieme di conferenze a cui qualsiasi studente (entro il limite massimo) può iscriversi e partecipare.
public struct Pack: Identifiable, Codable {
    
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
    
}
