 //
//  File.swift
//  SDSCore
//
//  Created by Sese on 23/02/25.
//

import Foundation

public protocol SDSEntity: Identifiable, Codable, Hashable {
    
    var id: String { get }
    
    func hash(into hasher: inout Hasher)
    
    static func == (lhs: Self, rhs: Self) -> Bool
    
}
