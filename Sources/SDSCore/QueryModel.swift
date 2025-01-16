//
//  QueryModel.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation
import CoreML
import NaturalLanguage

@available(iOS 17.0, *)
@available(macOS 14.0, *)

@Observable
public class QueryModel {
    
    public var query = ""
    
    public var tags: [String] = []
    
    public var cache: [String: [String]] = [:]
    
    func search(query: String) -> [String] {
        if let cachedResults = cache[query] {
            print("Results")
            return cachedResults
        }
        
        return []
    }
    
    func resetQuery() {
        query = ""
    }
    
    func getTags(for string: String) {
        do {
            let model = try FinderQueryModelEnchanced(configuration: MLModelConfiguration()).model
            let predictor = try NLModel(mlModel: model)
            
            let predictions = predictor.predictedLabelHypotheses(for: string, maximumCount: 4)
            
            tags = []
            
            for prediction in predictions {
                tags.append(prediction.key)
            }
            
        } catch {
            print("Error in tagging the query: \(error.localizedDescription), \(error)")
        }
    }
    
}
