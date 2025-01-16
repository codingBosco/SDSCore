//
//  Plesso.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Una delle sedi dell'istituto, nel quale si trovano le classi, se l'istituo è diviso in più plessi
///
///A partire dal 2023, L'istituto è stato suddiviso in due plessi distaccati. La sede centrale e il plesso San Luigi, distaccato. La suddivisione in plessi ha apportato delle modifiche all'organizzazione della SDS come:
///
///- Nomenclatura delle classi differente rispetto al plesso centrale
///-
///
///
///
public enum Plesso: String, Identifiable, Codable, CaseIterable {
    
    ///Il plesso centrale
    case centrale
    
    ///Il plesso San Luigi
    case sanluigi
    
    
    public var id: String {
        return "plex_\(rawValue)"
    }
    
    ///Il nome del plesso, visualizzato nelle diverse viste dell'app.
    public var formalPless: String {
        switch self {
        case .centrale:
            return "Plesso Centrale"
        case .sanluigi:
            return "San Luigi"
        }
    }
}
