//
//  Conference.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

///Un incontro tra gli studenti del pacchetto in cui è presente e dei relatori.
@Observable
public final class Conference: SDSEntity {
    
    public var id: String
    
    public var title: String
    public var abstract: String
    
    ///Determina se la conferenza si terrà online o in presenza
    public var isOnline: Bool
    
    ///L'indirizzo URL del meeting, se la conferenza si tiene online
    public var url: URL?
    
    ///I relatori
    public var attendences: [String]
    public var usefulContacts: [String]
    
    public var isExternal: Bool
    public var externalNotes: String
    
    public init(id: String = UUID().uuidString, title: String, abstract: String, isOnline: Bool, url: URL? = nil, attendences: [String], usefulContacts: [String], isExternal: Bool, externalNotes: String) {
        self.id = id
        self.title = title
        self.abstract = abstract
        self.isOnline = isOnline
        self.url = url
        self.attendences = attendences
        self.usefulContacts = usefulContacts
        self.isExternal = isExternal
        self.externalNotes = externalNotes
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Conference, rhs: Conference) -> Bool {
        lhs.id == rhs.id
    }
    
    
}

extension Conference {
    
    public static var newConference: Conference {
        return Conference(title: "", abstract: "", isOnline: false, attendences: [], usefulContacts: [], isExternal: false, externalNotes: "")
    }
    
}
