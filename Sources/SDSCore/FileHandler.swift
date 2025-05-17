//
//  FileHandler.swift
//  SDSCore
//
//  Created by Sese on 18/04/25.
//

import SwiftUI

@Observable
public class FileHandler {
    
    public var isHandling = false
    
    public var handledFileData: Data = Data()
    
    public var fileSubscription: [Subscription] = []
    
    public init() { }
    
    public func handleFile(_ result: Result<URL, Error>) async {
        switch result {
        case .success(let file):
            
            if file.startAccessingSecurityScopedResource() {
                do {
                    isHandling = true
                    handledFileData = try Data(contentsOf: file)
                    
                    await rationalCSVParsing(fromData: handledFileData)
                    
                } catch {
                    print("Error in file reading and parsing, \(error.localizedDescription)")
                }
            }
            
        case .failure(let failure):
            print("Failed to import the file with error: \(failure.localizedDescription)")
        }
    }
    
    public func rationalCSVParsing(fromData data: Data) async {
        
        var imports: [[String]] = []
        
        let content = String(data: data, encoding: .utf8)
        
        //TODO: Add throw statement to handle error in file reading
        guard let content = content else { return }
        
        let rows = content.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            imports.append(columns)
        }
        
        imports.removeFirst(2)
        
        imports.forEach { data in
            let cleanData = data.map { $0.cleaned() }
            
            let timestamp = cleanData[0]
            
            let surname = cleanData[1].capitalized
            let name = cleanData[2].capitalized
            
            let classNumber = cleanData[3]
            let classSection = cleanData[4]
            
            let newSubscription = Subscription(
                name: name,
                surname: surname,
                class_num: classNumber,
                class_sez: classSection,
                subscriptionTimestamp: timestamp
            )
            
            fileSubscription.append(newSubscription)
            
        }
        
    }
    
}
