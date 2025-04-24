//
//  Student.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

//MARK: Student
///Una persona che frequenta le classi e partecipa ai pacchetti della SDS
@DebugDescription
@Observable
public final class Student: SDSEntity {
    
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
    public var isIgnored: [StudentException]
    
    ///Gli IDs dei Pacchetti in cui lo studente è moderatore
    public var isModerator: [String]
    
    public init(id: String = UUID().uuidString, name: String, surname: String, classe: String, attendedPacks: [String], isGuardian: [String], isIgnored: [StudentException], isModerator: [String]) {
        self.id = id
        self.name = name
        self.surname = surname
        self.classe = classe
        self.attendedPacks = attendedPacks
        self.isGuardian = isGuardian
        self.isIgnored = isIgnored
        self.isModerator = isModerator
    }
    
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.surname, forKey: .surname)
        try container.encode(self.classe, forKey: .classe)
        try container.encode(self.attendedPacks, forKey: .attendedPacks)
        try container.encode(self.isGuardian, forKey: .isGuardian)
        try container.encode(self.isIgnored, forKey: .isIgnored)
        try container.encode(self.isModerator, forKey: .isModerator)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case surname
        case classe = "classroom"
        case attendedPacks
        case isGuardian
        case isIgnored
        case isModerator
    }
    
    required public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.surname = try container.decode(String.self, forKey: .surname)
        self.classe = try container.decode(String.self, forKey: .classe)
        self.attendedPacks = try container.decode([String].self, forKey: .attendedPacks)
        self.isGuardian = try container.decode([String].self, forKey: .isGuardian)
        self.isIgnored = try container.decode([StudentException].self, forKey: .isIgnored)
        self.isModerator = try container.decode([String].self, forKey: .isModerator)
    }
    
    public var debugDescription: String {
        "\(name) \(surname) - \(classe)"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Student, rhs: Student) -> Bool {
        lhs.id == rhs.id
    }
    
}

public struct StudentException: Codable, Hashable {
    public let day: String
    
    public var additionalNotes: String
    
    public var ignoranceSummary : String
    
    public init(day: String, additionalNotes: String, ignoranceSummary: String) {
        self.day = day
        self.additionalNotes = additionalNotes
        self.ignoranceSummary = ignoranceSummary
    }
    
}

extension Student {
    
    public static var newStudent: Student {
        return Student(name: "", surname: "", classe: "", attendedPacks: [], isGuardian: [], isIgnored: [], isModerator: [])
    }
    
}
