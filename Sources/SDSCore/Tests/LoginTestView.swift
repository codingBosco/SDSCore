//
//  LoginTestView.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct LoginTestView: View {
    @State var db = SDSLDBModel()
    
    @State private var username: String = ""
    @State private var secureCode: String = ""
    
    var body: some View {
        VStack {
            
            TextField("Username", text: $username)
            
            TextField("Secure Code", text: $secureCode)
            
            Button("Login") {
                
            }
           
            
        }
    }
    
    
    
}

@available(iOS 17.0, *)
#Preview {
    LoginTestView()
        .environment(SDSLDBModel())
}
