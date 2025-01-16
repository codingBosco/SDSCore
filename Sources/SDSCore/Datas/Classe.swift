//
//  Classe.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

//MARK: Classe
///Una classe dell'istituto
public struct Classe: Identifiable, Codable {
    
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
    
}
