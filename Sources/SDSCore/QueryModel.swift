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
//TODO: To rename to QueryCore
public class QueryModel {
    
    ///La ricerca effettuata dall'utente.
    ///
    ///## Topics
    ///
    ///
    ///- ``resetQuery()``
    ///
    public var query = ""
    
    ///Gli elementi inclusi nella ricerca, identificati dal modello di Machine Learning
    ///
    ///
    ///Ogni volta che si effettua una nuova ricerca, l'app richiama un modello di Machine Learning integrato in modo tale da riconoscere gli elementi richiesti dalla ricerca.
    ///
    ///Ad ogni modifica del valore ``query``, l'app richiama la funzione ````
    ///
    ///## Tag & Tipi di Elementi
    ///
    ///
    ///## Intepretare i risultati
    ///
    ///
    ///> Warning: Il modello è basato su formule della ricerca standard. In alcuni casi, potrebbe restituire risultati inaspettati o non conformi alla ricerca effettuata. Assicuratevi di
    ///
    public var tags: [String] = []
    
    
    ///Una raccolta di dati compressi che rappresentano le ricerche precedenti.
    ///
    ///
    ///
    public var cache: [String: [String]] = [:]
    
    public init(
        query: String = "",
        tags: [String] = [],
        cache: [String : [String]] = [:]
    ) {
        self.query = query
        self.tags = tags
        self.cache = cache
    }
    
    public func search(query: String) -> [String] {
        if let cachedResults = cache[query] {
            print("Results")
            return cachedResults
        }
        
        return []
    }
    
    
    ///Ripristina la ricerca effettuata azzerando il valore query.
    public func resetQuery() {
        query = ""
    }
    
    public func getTags(for string: String) {
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

