//
//  Subscription.swift
//  SDSKit
//
//  Created by Sese on 29/12/24.
//

import Foundation

///Una struttura che rappresenta un iscrizione di un alunno ad un determinato pacchetto (corrispondente al file da cui proviene l'iscrizione stessa)
public struct Subscription: Identifiable {
    
    public var id: String
    public var name: String
    public var surname: String
    
    public var class_num: String
    public var class_sez: String
    
    public var subscriptionTimestamp: String
    
    public init(id: String = UUID().uuidString, name: String, surname: String, class_num: String, class_sez: String, subscriptionTimestamp: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.class_num = class_num
        self.class_sez = class_sez
        self.subscriptionTimestamp = subscriptionTimestamp
    }
    
}
