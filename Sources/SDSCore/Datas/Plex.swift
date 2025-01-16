//
//  Plesso.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Una delle sedi dell'istituto, nel quale si trovano le classi,
public enum Plesso: String, Identifiable, Codable, CaseIterable {
    
    case centrale
    case sanluigi
    
    public var id: String {
        return "plex_\(rawValue)"
    }
    
    public var formalPless: String {
        switch self {
        case .centrale:
            return "Plesso Centrale"
        case .sanluigi:
            return "San Luigi"
        }
    }
}
