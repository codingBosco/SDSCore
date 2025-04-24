//
//  HostCapabilitiesRow.swift
//  SDSCore
//
//  Created by Sese on 12/01/25.
//

import SwiftUI

struct HostCapabilitiesRow: View {
    let info: HostCapabilityReport
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Report of: \(info.timestamp)")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
            }
            
            HStack(alignment: .top){
                
                Text("\(info.system) System")
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(info.networkInfo.ipAddress)
                    Text(info.networkInfo.macAddress).font(.caption2)
                }
                
            }
            
            VStack{
                
                HStack {
                    Text("CPU")
                        .font(.caption).foregroundStyle(.secondary).bold()
                    Spacer()
                }
                
                HStack {
                    
                    Text("\(info.cpuInfo.model), \(Int(info.cpuInfo.cores)) cores")
                        .font(.caption2).foregroundStyle(.secondary)
                    
                    Spacer()
                    
                }
                
                let totalMemory = Double(info.ramMemory.free.subValue ?? 0)
                let usedMemory = Double(info.ramMemory.used.subValue ?? 0)

                
                Gauge(value: (totalMemory - usedMemory), in: 0...totalMemory) {
                    Text("RAM Usage")
                } currentValueLabel: {
                    EmptyView()
                } minimumValueLabel: {
                    Text("\(info.ramMemory.free) free")
                        .font(.caption2.bold())
                        .foregroundStyle((totalMemory - usedMemory) < 10 ? .red : .blue)
                } maximumValueLabel: {
                    Text(info.ramMemory.total)
                }.gaugeStyle(.accessoryLinear)
                    .padding()

                    
                Text("\(info.ramMemory.server) used by the server.")
                    .font(.subheadline)

      
            }
            
            Divider()
            
            VStack{
                
                HStack {
                    Text("Disk")
                        .font(.caption).foregroundStyle(.secondary).bold()
                    Spacer()
                }
                
              let total = Double(info.diskInfo.total.subValue ?? 0)
                let used = Double(info.diskInfo.used.subValue ?? 0)
                
                Gauge(value: (total - used), in: 0...total) {
                    Text("Disk Usage")
                } currentValueLabel: {
                    EmptyView()
                } minimumValueLabel: {
                    Text("\(info.diskInfo.free) free")
                } maximumValueLabel: {
                    Text(info.diskInfo.total)
                }.gaugeStyle(.accessoryLinear)
                    .padding()
                
                Text("\(info.diskInfo.server) used by the server.")
                
            }
            
            Divider()
            
            VStack(spacing: 10) {
                HStack {
                    
                    Text("Network")
                        .font(.caption).foregroundStyle(.secondary).bold()
                    Spacer()
                }
                
                HStack {
                    Text("Total Received Data:")
                        .font(.subheadline)
                    Spacer()
                    Text("\(info.networkInfo.bytesReceived)").bold()
                }
                
                HStack {
                    Text("Total Sent Data:")
                        .font(.subheadline)
                    Spacer()
                    Text("\(info.networkInfo.bytesSent)").bold()
                }
                
            }
  
                
            
                   
        }.padding()
    }
}

#Preview(traits: .sizeThatFitsLayout){
    HostCapabilitiesRow(
        info: .init(
            timestamp: Date().formatted(date: .complete, time: .complete),
            system: "macOS",
            ramMemory: .init(total: "48.00 GB", used: "47.64 GB", free: "50.97 MB", server: "89.65 MB"),
            cpuInfo: .init(model: "Apple M4 Pro", cores: 14),
            diskInfo: .init(total: "931.97 GB", used: "306.97 GB", free: "124.97 GB", server: "124.97 MB"),
            networkInfo: .init(ipAddress: "198.168.1.1", macAddress: "22:22:22:22:22:22", bytesSent: "3.99GB", bytesReceived: "17.82GB")
        )
    )
}

extension String {
    
    var value: Int? {
        Int(self.filter({ $0.isNumber }))
    }
    
    var subValue: Double? {
        Double(self.filter({ $0.isNumber }))
    }
    
}
