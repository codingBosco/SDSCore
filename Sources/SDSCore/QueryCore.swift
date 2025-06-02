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
public class QueryCore {
    
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
    
    public func getTags() -> [Substring: String]? {
        
        var tags : [Substring: String] = [:]
        
        do {
            let model = try SDSQueryAssistant_V1_25I(configuration: MLModelConfiguration()).model
            let customModel = try NLModel(mlModel: model)
            
            let customTagScheme = NLTagScheme("Query Tags Scheme")
            let tagger = NLTagger(tagSchemes: [.nameType, .lexicalClass, customTagScheme])
            tagger.string = query
            
            tagger.setModels([customModel], forTagScheme: customTagScheme)
            
            tagger.enumerateTags(in: query.startIndex..<query.endIndex, unit: .word, scheme: customTagScheme, options: [.omitWhitespace,.omitPunctuation]) { tag, tokenRange in
                if let tag = tag {
                    tags = [query[tokenRange] : tag.rawValue]
                }
                
               return true
            }
            
            return tags
            
        } catch {
            print("Error in ml: \(error)")
            return nil
        }
        
        return tags
    }
    
}

