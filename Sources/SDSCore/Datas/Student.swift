//
//  Student.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

//MARK: Student
///Una persona che frequenta le classi e partecipa ai pacchetti della SDS
public struct Student: Identifiable, Codable {
    
    public var id: String
    
    ///Il nome dello studente
    public var name: String
    
    ///Il cognome dello studente
    public var surname: String
    
    ///L'id della classe frequentata dallo studente. Questa non corrisponde alla classe nella quale lo studente si trova durante la sds
    public var classe: String
    
    ///I Pacchetti a cui lo studente partecipa. L'array contiene gli identificativi dei pacchetti. Questi esistono già nel db, e l'app si occuperà di ottenere, dagli id, il pacchetto corretto e mostrarlo.
    public var attendedPacks: [String]
    
    ///Se lo studente , in una giornata, fa parte del servizio d'ordine, l'ID del giorno sarà presente in questo array
    public var isGuardian: [String]
    
    ///Se lo studente tiene una conferenza (o non è disponibile)
    public var isIgnored: [IgnoredStudentState]
    
    ///Gli IDs dei Pacchetti in cui lo studente è moderatore
    public var isModerator: [String]
    
    public init(id: String = UUID().uuidString, name: String, surname: String, classe: String, attendedPacks: [String], isGuardian: [String], isIgnored: [IgnoredStudentState], isModerator: [String]) {
        self.id = id
        self.name = name
        self.surname = surname
        self.classe = classe
        self.attendedPacks = attendedPacks
        self.isGuardian = isGuardian
        self.isIgnored = isIgnored
        self.isModerator = isModerator
    }
    
}

public struct IgnoredStudentState: Codable {
    public let day: String
    
    public var additionalNotes: String
    
    public var ignoranceSummary : String
    
}
