//
//  LocalCore.swift
//  SDSCore
//
//  Created by Sese on 24/04/25.
//

import Foundation


//
//public class SDSLocalCore {
//    
//    var students: [Student] = []
//    var tranches: [Tranche] = []
//    var days: [Day] = []
//    var classes: [Classe] = []
//    var conferences: [Conference] = []
//    var packs: [Pack] = []
//    
//    public init() {
//        
//    }
//    
//    
//    
//    private static var localDocumentDirectory: URL {
//        do {
//            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        } catch {
//            fatalError("Couldn't get document directory, error: \(error.localizedDescription)")
//        }
//    }
//    
//    private static var tranchesFile: URL {
//        return localDocumentDirectory.appendingPathComponent("tranches.data")
//    }
//    
//    private static var packsFile: URL {
//        return localDocumentDirectory.appendingPathComponent("packs.data")
//    }
//    
//    private static var classesFile: URL {
//        return localDocumentDirectory.appendingPathComponent("classes.data")
//    }
//    
//    private static var conferencesFile: URL {
//        return localDocumentDirectory.appendingPathComponent("conferences.data")
//    }
//    
//    private static var studentsFile: URL {
//        return localDocumentDirectory.appendingPathComponent("students.data")
//    }
//    
//    private static var daysFile: URL {
//        return localDocumentDirectory.appendingPathComponent("days.data")
//    }
//    
//    public func load() async throws {
//        try await students = load(itemType: .students)
//        try await classes = load(itemType: .classes)
//        try await tranches = load(itemType: .tranche)
//        try await conferences = load(itemType: .conferences)
//        try await days = load(itemType: .days)
//        try await packs = load(itemType: .packs)
//    }
//    
//    public func save() async throws {
//        try await save(items: students, for: .students)
//        try await save(items: packs, for: .packs)
//        try await save(items: conferences, for: .conferences)
//        try await save(items: days, for: .days)
//        try await save(items: classes, for: .classes)
//        try await save(items: tranches, for: .tranche)
//    }
//    
//    public func load<T: SDSEntity>(itemType: ItemEntity) async throws -> [T] {
//        do {
//            guard let data = try? Data(contentsOf: itemType.directoryURL) else {
//                throw ServerError.decodingError
//            }
//            
//            let items = try JSONDecoder().decode([T].self, from: data)
//            return items
//        } catch {
//            print("Couldn't load students, due to: \(error.localizedDescription)")
//            return []
//        }
//    }
//    
//    public func save<T: SDSEntity>(items: [T], for itemType: ItemEntity) async throws {
//        do {
//            let data = try JSONEncoder().encode(items)
//            let output = itemType.directoryURL
//            try data.write(to: output)
//        } catch {
//            print("Could't save the files")
//        }
//    }
//    
//    
//}
