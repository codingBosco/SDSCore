//
//  String+Clean.swift
//  SDSKit
//
//  Created by Sese on 18/04/25.
//

import Foundation

//TODO: Better manage of file handling
extension String {
    
    public func cleaned() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
    
}
