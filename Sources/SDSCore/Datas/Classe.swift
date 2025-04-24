//
//  Classe.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

//MARK: Classe
///Una classe dell'istituto
@Observable
public class Classe: SDSEntity {
    
    public var id: String
    
    ///L'ingreddo predefinito della classe
    public var ingresso: String
    
    
    ///La posizione nel plesso della classe
    public var ubicazione: String
    
    ///Il numero della classe
    public var classNum: String
    
    ///Il numero massimo di studenti autorizzati ad accedere
    public var maxNum: Int
    
    ///Il nome formale della classe, come 1F o 3H
    public var formalClass: String
    
    ///Il numero di studenti che, nell'orario regolare, vi partecipano
    public var studentsNum: Int
    
    
    ///Indica se la classe è disponibile per ospitare eventuali conferenze
    public var isAvaible: Bool
    
    
    ///Il plesso nel quale si trova la classe
    public var plesso: Plesso
    
    public init(id: String = UUID().uuidString, ingresso: String, ubicazione: String, classNum: String, maxNum: Int, formalClass: String, studentsNum: Int, isAvaible: Bool, plesso: Plesso) {
        self.id = id
        self.ingresso = ingresso
        self.ubicazione = ubicazione
        self.classNum = classNum
        self.maxNum = maxNum
        self.formalClass = formalClass
        self.studentsNum = studentsNum
        self.isAvaible = isAvaible
        self.plesso = plesso
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Classe, rhs: Classe) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ingresso = "entrance"
        case ubicazione = "position"
        case classNum = "num"
        case maxNum = "max"
        case formalClass = "formal"
        case studentsNum
        case isAvaible = "avaible"
        case plesso = "plex"
    }
    
    public func encode(to encoder: any Encoder) throws {
        var ct = encoder.container(keyedBy: CodingKeys.self)
        try ct.encode(id, forKey: .id)
        try ct.encode(ingresso, forKey: .ingresso)
        try ct.encode(ubicazione, forKey: .ubicazione)
        try ct.encode(classNum, forKey: .classNum)
        try ct.encode(maxNum, forKey: .maxNum)
        try ct.encode(formalClass, forKey: .formalClass)
        try ct.encode(studentsNum, forKey: .studentsNum)
        try ct.encode(isAvaible, forKey: .isAvaible)
        try ct.encode(plesso, forKey: .plesso)
    }
    
    public required init(from decoder: any Decoder) throws {
        let ct = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try ct.decode(String.self, forKey: .id)
        self.ingresso = try ct.decode(String.self, forKey: .ingresso)
        self.ubicazione = try ct.decode(String.self, forKey: .ubicazione)
        self.classNum = try ct.decode(String.self, forKey: .classNum)
        self.maxNum = try ct.decode(Int.self, forKey: .maxNum)
        self.formalClass = try ct.decode(String.self, forKey: .formalClass)
        self.studentsNum = try ct.decode(Int.self, forKey: .studentsNum)
        self.isAvaible = try ct.decode(Bool.self, forKey: .isAvaible)
        self.plesso = try ct.decode(Plesso.self, forKey: .plesso)
        
    }
    
    
}

extension Classe {
    
    public static var newClass: Classe {
        return Classe(ingresso: "", ubicazione: "", classNum: "", maxNum: 0, formalClass: "", studentsNum: 0, isAvaible: true, plesso: .centrale)
    }
    
}
