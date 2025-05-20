//
//  Block.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation

enum Block: String, Identifiable, CaseIterable, Codable {
    case first
    case second
    case third
    case fourth
    
    case outOfBlock
    
    public var id: String {
        return "\(rawValue).id"
    }
    
    public var formal: String {
        switch self {
        case .first:
            return "1° Blocco"
        case .second:
            return "2° Blocco"
        case .third:
            return "3° Blocco"
        case .fourth:
            return "4° Blocco"
        case .outOfBlock:
            return "Fuori Orario"
        }
    }
    
    static func getBlock(for date: Date) -> Block {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.month, from: date)
        let totalMinutes = hour * 60 + minute
        
        print(totalMinutes)
        
        switch totalMinutes {
        case 480..<580: // 8:00 - 9:40
            return .first
        case 581..<660: // 9:40 - 11:00
            return .second
        case 675..<755: // 11:15 - 12:35
            return .third
        case 756..<840: // 12:35 - 14:00
            return .fourth
        default:
            return .outOfBlock
        }
    }
}
