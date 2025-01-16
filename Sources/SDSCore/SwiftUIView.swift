//
//  SwiftUIView.swift
//  SDSCore
//
//  Created by Sese on 12/01/25.
//

import SwiftUI


struct SwiftUIView: View {
    @State var db =  DatabaseModel()
    @State var hostReport: [HostCapabilityReport] = []
    @State var singleReport: HostCapabilityReport?
    
    @State var checkingSystemsHealth = false
    
    var body: some View {
        NavigationStack {
            List {
                
                Button(action: {
                    
                    Task {
                        do {
                            withAnimation {
                                checkingSystemsHealth = true
                            }
                            
                            hostReport = []
                            
                            let newData: Data? = await DatabaseModel().get(.init(apiRoute: .hostReport))
                            
                            hostReport = await test()
                            
                            withAnimation {
                                checkingSystemsHealth = false
                            }
                            
                        }
                    }
                    
                }) {
                    Text("Check System Health")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(alignment: .trailing) {
                            if checkingSystemsHealth {
                                ProgressView()
                                    .padding()
                            }
                        }
                }
                
                
                ForEach(hostReport.compactMap({ $0.timestamp }).sorted(by: { u1, u2 in
                    u2 < u1
                }), id: \.self) { day in
                    Section {
                        ForEach(hostReport.filter({ $0.timestamp == day}), id: \.timestamp) { report in
                            HostCapabilitiesRow(info: report)
                                .padding(-20)
                                .swipeActions {
                                    Button(action: {
                                        Task {
                                            
                                        }
                                    }) {
                                        Text("Remove")
                                    }
                                }
                        }
                    } header: {
                        Text(day)
                    }
                }
                
            }.navigationTitle("Host Health Reports")
        }.task {
            hostReport = await test()
        }
    }
    
  
    
}

func test() async -> [HostCapabilityReport] {
    do {
        
        let data: Data? = await DatabaseModel().get(.init(apiRoute: .hostReportHistory))
        
        let hostReport = try JSONDecoder().decode([HostCapabilityReport].self, from: data!)
    
        
        return hostReport
        
    } catch {
        print("Error in testing, \(error)")
        return []
    }
}

func singleTest() async -> HostCapabilityReport? {
    do {
        
        let data: Data? = await DatabaseModel().get(.init(apiRoute: .hostReport))
        
        let hostReport = try JSONDecoder().decode(HostCapabilityReport.self, from: data!)
        
        
        return hostReport
    } catch {
        print("Error in testing, \(error)")
        return nil
    }
}

#Preview {
    SwiftUIView()
}
