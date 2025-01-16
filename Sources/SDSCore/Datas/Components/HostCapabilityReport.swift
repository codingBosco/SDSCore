//
//  HostCapabilityReport.swift
//  SDSCore
//
//  Created by Sese on 06/01/25.
//

import Foundation

struct HostCapabilityReport: Codable {
    
    var timestamp: String
    var system: String
    var ramMemory: HostRamInfo
    var cpuInfo: HostCPUInfo
    var diskInfo: HostDiskInfo
    var networkInfo: HostNetworkInfo
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case system = "os"
        case ramMemory = "ram"
        case cpuInfo = "cpu"
        case diskInfo = "disk"
        case networkInfo = "network"
    }
    
    init(
        timestamp: String,
        system: String,
        ramMemory: HostRamInfo,
        cpuInfo: HostCPUInfo,
        diskInfo: HostDiskInfo,
        networkInfo: HostNetworkInfo
    ) {
        self.timestamp = timestamp
        self.system = system
        self.ramMemory = ramMemory
        self.cpuInfo = cpuInfo
        self.diskInfo = diskInfo
        self.networkInfo = networkInfo
    }
    
    
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.system, forKey: .system)
        try container.encode(self.ramMemory, forKey: .ramMemory)
        try container.encode(self.cpuInfo, forKey: .cpuInfo)
        try container.encode(self.diskInfo, forKey: .diskInfo)
        try container.encode(self.networkInfo, forKey: .networkInfo)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp) ?? "\(Date())"
        self.system = try container.decode(String.self, forKey: .system)
        self.ramMemory = try container.decode(HostRamInfo.self, forKey: .ramMemory)
        self.cpuInfo = try container.decode(HostCPUInfo.self, forKey: .cpuInfo)
        self.diskInfo = try container.decode(HostDiskInfo.self, forKey: .diskInfo)
        self.networkInfo = try container.decode(HostNetworkInfo.self, forKey: .networkInfo)
    }
    
    
    
}




extension HostCapabilityReport {
    struct HostCPUInfo: Codable {
        var model: String
        var cores: Int
        
        init(model: String, cores: Int) {
            self.model = model
            self.cores = cores
        }
    }
    
    struct HostRamInfo: Codable {
        var total: String
        var used: String
        var free: String
        var server: String
        
        enum CodingKeys: String, CodingKey {
            case total
            case used
            case free
            case server = "server_used_ram"
        }
        
        init(total: String, used: String, free: String, server: String) {
            self.total = total
            self.used = used
            self.free = free
            self.server = server
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: HostCapabilityReport.HostRamInfo.CodingKeys.self)
            try container.encode(self.total, forKey: HostCapabilityReport.HostRamInfo.CodingKeys.total)
            try container.encode(self.used, forKey: HostCapabilityReport.HostRamInfo.CodingKeys.used)
            try container.encode(self.free, forKey: HostCapabilityReport.HostRamInfo.CodingKeys.free)
            try container.encode(self.server, forKey: HostCapabilityReport.HostRamInfo.CodingKeys.server)
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<HostCapabilityReport.HostRamInfo.CodingKeys> = try decoder.container(keyedBy: HostCapabilityReport.HostRamInfo.CodingKeys.self)
            self.total = try container.decode(String.self, forKey: HostCapabilityReport.HostRamInfo.CodingKeys.total)
            self.used = try container.decode(String.self, forKey: HostCapabilityReport.HostRamInfo.CodingKeys.used)
            self.free = try container.decode(String.self, forKey: HostCapabilityReport.HostRamInfo.CodingKeys.free)
            self.server = try container.decode(String.self, forKey: HostCapabilityReport.HostRamInfo.CodingKeys.server)
        }
        
    }
    
    struct HostDiskInfo: Codable {
        var total: String
        var used: String
        var free: String
        var server: String
        
        enum CodingKeys: String, CodingKey {
            case total
            case used
            case free = "available"
            case server = "server_folder_size"
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: HostCapabilityReport.HostDiskInfo.CodingKeys.self)
            try container.encode(self.total, forKey: HostCapabilityReport.HostDiskInfo.CodingKeys.total)
            try container.encode(self.used, forKey: HostCapabilityReport.HostDiskInfo.CodingKeys.used)
            try container.encode(self.free, forKey: HostCapabilityReport.HostDiskInfo.CodingKeys.free)
            try container.encode(self.server, forKey: HostCapabilityReport.HostDiskInfo.CodingKeys.server)
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<HostCapabilityReport.HostDiskInfo.CodingKeys> = try decoder.container(keyedBy: HostCapabilityReport.HostDiskInfo.CodingKeys.self)
            self.total = try container.decode(String.self, forKey: HostCapabilityReport.HostDiskInfo.CodingKeys.total)
            self.used = try container.decode(String.self, forKey: HostCapabilityReport.HostDiskInfo.CodingKeys.used)
            self.free = try container.decode(String.self, forKey: HostCapabilityReport.HostDiskInfo.CodingKeys.free)
            self.server = try container.decode(String.self, forKey: HostCapabilityReport.HostDiskInfo.CodingKeys.server)
        }
        
        init(total: String, used: String, free: String, server: String) {
            self.total = total
            self.used = used
            self.free = free
            self.server = server
        }
    }
    
    struct HostNetworkInfo: Codable {
        var ipAddress: String
        var macAddress: String
        var bytesSent: String
        var bytesReceived: String
        
        enum CodingKeys: String, CodingKey {
            case ipAddress = "server_ip_address"
            case macAddress = "server_mac_address"
            case bytesSent = "sent"
            case bytesReceived = "received"
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: HostCapabilityReport.HostNetworkInfo.CodingKeys.self)
            try container.encode(self.ipAddress, forKey: HostCapabilityReport.HostNetworkInfo.CodingKeys.ipAddress)
            try container.encode(self.macAddress, forKey: HostCapabilityReport.HostNetworkInfo.CodingKeys.macAddress)
            try container.encode(self.bytesSent, forKey: HostCapabilityReport.HostNetworkInfo.CodingKeys.bytesSent)
            try container.encode(self.bytesReceived, forKey: HostCapabilityReport.HostNetworkInfo.CodingKeys.bytesReceived)
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<HostCapabilityReport.HostNetworkInfo.CodingKeys> = try decoder.container(keyedBy: HostCapabilityReport.HostNetworkInfo.CodingKeys.self)
            self.ipAddress = try container.decode(String.self, forKey: HostCapabilityReport.HostNetworkInfo.CodingKeys.ipAddress)
            self.macAddress = try container.decode(String.self, forKey: HostCapabilityReport.HostNetworkInfo.CodingKeys.macAddress)
            self.bytesSent = try container.decode(String.self, forKey: HostCapabilityReport.HostNetworkInfo.CodingKeys.bytesSent)
            self.bytesReceived = try container.decode(String.self, forKey: HostCapabilityReport.HostNetworkInfo.CodingKeys.bytesReceived)
        }
        
        init(ipAddress: String, macAddress: String, bytesSent: String, bytesReceived: String) {
            self.ipAddress = ipAddress
            self.macAddress = macAddress
            self.bytesSent = bytesSent
            self.bytesReceived = bytesReceived
        }
        
    }
}
