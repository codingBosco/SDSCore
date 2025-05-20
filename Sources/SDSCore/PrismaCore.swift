//
//  File.swift
//  SDSCore
//
//  Created by Sese on 18/05/25.
//

import Foundation
import CoreML
import MetalKit
import Accelerate
import NaturalLanguage

@Observable
public class PrismaCore {
    
    public init() {  }
    
    public func predict(_ text: String) async {
        do {
            let model = try SDSPrismaOne(configuration: MLModelConfiguration()).model
            let customModel = try NLModel(mlModel: model)
            
            let customTagScheme = NLTagScheme("List Terminology")
            let tagger = NLTagger(tagSchemes: [.nameType, .lexicalClass, customTagScheme])
            tagger.string = text
            
            tagger.setModels([customModel], forTagScheme: customTagScheme)
            
            tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: customTagScheme, options: [.omitWhitespace,.omitPunctuation]) { tag, tokenRange in
                if let tag = tag {
                    print("\(text[tokenRange]): \(tag.rawValue)")
                }
                return true
            }
        } catch {
            print("Error in ml: \(error)")
        }
    }
    
    
}
