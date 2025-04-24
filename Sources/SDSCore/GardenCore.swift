//
//  GardenCore.swift
//  SDSCore
//
//  Created by Sese on 24/04/25.
//

import Foundation
import MultipeerConnectivity
import CoreBluetooth
import NearbyInteraction

public struct GardenPeerError: Error {
    
}

public enum DeviceHierarchicalPosition: String, CaseIterable, Codable {
    
    case host
    case client
    case serverClient
    
    public var id: String {
        return rawValue
    }
    
    public var label: String {
        return rawValue.capitalized
    }

    public enum CodingKeys: String, CodingKey {
        case value
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawValue, forKey: .value)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .value)
        guard let value = DeviceHierarchicalPosition(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "Invalid role value")
        }
        self = value
    }
}


@Observable
@MainActor
public final class GardenCore: NSObject {
    
    
    public var hierarchy: DeviceHierarchicalPosition = .host
    
    ///The Session ID for the multipeer connection
    private let serviceType = "sds-sync"
    
    ///The device MultiPeerConnectivity ID
    #if os(iOS)
    private let deviceID = MCPeerID(displayName: "\(UIDevice.current.name)_\(UUID().uuidString)")
    #elseif os(macOS)
    private let deviceID = MCPeerID(displayName: "\(Host.current().name)_\(UUID().uuidString)")
    #endif
    
    
    ///A single string message
    public var message = ""
    
    ///Defines if the message is being showed in the UI
    public var showMessage = false

    ///A Boolean value for UI update whenever datas are being sended to the peers
    public var isSendingData = false
    
    ///A Boolean value for UI update whenever the device is receiving datas from other peers
    public var isReceivingData = false
    
    ///The session of the MultiPeerConnectivity Framework
    private var peerSession: MCSession!
    
    ///The core of the Bluetooth Framework
    private var bluetoothCore: CBCentralManager!
    ///The core of the Peripheral Manager.
    private var peripheralCore: CBPeripheralManager!
    
    
    ///A list of nearby bluetooth device
    public var discoveredPeripherals: [CBPeripheral] = []
    
    ///The list of the bluetooth devices connect to the current device
    public var connectedPeripherals: [CBPeripheral] = []
    
    ///A temporary-selected bluetooth device for peer connectivity and intiial setups
    public var selectedPeripherals: CBPeripheral?
    
    ///The service ID for bluetooth data exchaning
    private let textServiceUUID = CBUUID(string: "42332fe8-9915-11ea-bb37-0242ac130002")
    ///The service ID for bluetooth data characteristics exchanging
    private let textCharacteristicsUUID = CBUUID(string: "12345678-1234-1234-1234-1234567890AB")
    
    ///The default data characteristics used to match Bluetooth Devices
    private var hostSyncCharacteristics: CBCharacteristic?
    private var clientSyncCharacteristics: CBMutableCharacteristic?
    
    public override init() {
        super.init()
        
        setupSession()
        
        if hierarchy == .host {
            bluetoothCore = CBCentralManager(delegate: self, queue: nil)
            bluetoothCore.scanForPeripherals(withServices: [textServiceUUID])
        } else {
            peripheralCore = CBPeripheralManager(delegate: self, queue: nil)
        }
        
    }
    
    //MARK: Multipeer
    
    private func setupSession() {
        peerSession = MCSession(
            peer: deviceID,
            securityIdentity: nil,
            encryptionPreference: .required
        )
        peerSession.delegate = self

    }
    


    
    //MARK: Bluetooth
    
    public func scanPeripherals() {
        if hierarchy == .client {
            discoveredPeripherals.removeAll()
            peripheralCore.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey: [textServiceUUID]
            ])
            bluetoothCore.scanForPeripherals(withServices: [textServiceUUID])
            print("Start Bluetooth Scanning")
        }
    }
    
    public func stopScanPeripherals() {
        bluetoothCore.stopScan()
        print("Stopped Bluetooth Scanning")
    }
    
    public func connect(to peripheral: CBPeripheral) {
        if !connectedPeripherals.contains(peripheral) {
            bluetoothCore.connect(peripheral)
            // sendMPNotification() // Removed this line
        } else {
            print("\(peripheral.name ?? "Unknown") already connected")
        }
    }
    
    public func disconnect(from peripheral: CBPeripheral) {
        if connectedPeripherals.contains(peripheral) {
            bluetoothCore.cancelPeripheralConnection(peripheral)
            print("Disconnecting from \(peripheral.name ?? "Unknown")")
        }
    }
    
//    public func sendBluetooth() {
//        guard let peripheral = selectedPeripherals, let textChar else {
//            print("Error in bluetooth sending: \(String(describing: selectedPeripherals)) \(String(describing: textChar))")
//            return
//        }
//
//        Task {
//            do {
//                let message = RelationshipMessage(
//                    message: "Bluetooth connection anchored handshake",
//                    from: UIDevice.current.name,
//                    to: selectedPeripherals?.name ?? "Undefined Receiver Name: \(selectedPeripherals?.identifier)",
//                    isHandshakeRequired: false
//                )
//
//                let data = try JSONEncoder().encode(message)
//                peripheral.writeValue(data, for: textChar, type: .withResponse)
//
//
//            } catch {
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//
//    }
    
    public func sendMPNotification() {
        isSendingData = true
        guard let peripheral = selectedPeripherals else {
            print("Error: No peripheral selected.")
            isSendingData = false
            return
        }
        
        guard let textChar = hostSyncCharacteristics else {
            print("Error in bluetooth sending: hostSyncCharacteristics is nil.")
            isSendingData = false
            return
        }

        if peripheral.state == .connected {
            let multipeerNotification = RelationshipMessage(
                message: deviceID.displayName,
                from: deviceID.displayName,
                to: peripheral.name ?? "Unknown receiver",
                type: "mpnotify",
                isHandshakeRequired: false
            )
            
            guard let data = try? JSONEncoder().encode(multipeerNotification) else {
                print("Error encoding data.")
                isSendingData = false
                return
            }

            peripheral.writeValue(data, for: textChar, type: .withResponse)
        } else {
            print("Peripheral \(peripheral.name ?? "Unknown") with identifier \(peripheral.identifier) is not connected, cannot send notification.")
            isSendingData = false
        }
    }
    
}

//MARK: CoreBluetooth Extension

extension GardenCore: @preconcurrency CBCentralManagerDelegate, @preconcurrency CBPeripheralManagerDelegate {
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            self.discoveredPeripherals.append(peripheral)
        }
        
        peripheral.delegate = self
        peripheral.discoverServices([textServiceUUID])
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if let error = error {
            print("Error discovering chars, \(error.localizedDescription)")
            return
        }
        
        if let chars = service.characteristics {
            for char in chars {
                if char.uuid == textCharacteristicsUUID {
                    print("[DEBUG] Discovered correct characteristic: \(char)")
                    hostSyncCharacteristics = char
                    return
                }
            }
        }
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting bluetooth")
        case .unsupported:
            print("Unsupported bluetooth")
        case .unauthorized:
            print("Unauthorized bluetooth")
        case .poweredOff:
            print("Bluetooth powered off, \(central.state)")
            stopScanPeripherals()
        case .poweredOn:
            print("On")
        @unknown default:
            fatalError("Bluetooth fatal error")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if !self.connectedPeripherals.contains(peripheral) {
            self.connectedPeripherals.append(peripheral)
        }
        
        print("[DELEGATE]: Device \(peripheral.name) connected")
        selectedPeripherals = peripheral
        
#if os(iOS)
let messageString = "connected: \(UIDevice.current.name)"
    #elseif os(macOS)
let messageString = "connected: Mac"
#endif

#if os(iOS)
let fromString = UIDevice.current.name
#else
let fromString = "mac"
#endif
        
        let message = RelationshipMessage(
            message: messageString,
            from: fromString,
            to: peripheral.name ?? "unknown",
            type: "connection",
            isHandshakeRequired: false
        )

        if let data = try? JSONEncoder().encode(message),
           let textChar = hostSyncCharacteristics {
            peripheral.writeValue(data, for: textChar, type: .withResponse)
        }
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        self.connectedPeripherals.removeAll(where: { $0 == peripheral })
        print("Disconnected: \(peripheral.name ?? "Unknown")")
        if let error = error {
            print("Disconnection error for \(peripheral.name ?? "Unknown") with identifier \(peripheral.identifier): \(error.localizedDescription)")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        print("Failed connection with \(peripheral.name ?? "Unknown")")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if let error = error {
            print("Error receiving data: \(error.localizedDescription)")
            return
        }
        
        if characteristic.uuid == textCharacteristicsUUID, let value = characteristic.value {
            if let text = String(data: value, encoding: .utf8) {
                message = "Received from \(peripheral.name ?? "Unknown"), \(text)"
                showMessage = true
                print("Received")
            }
        }
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid == textCharacteristicsUUID,
               let value = request.value{
                
                guard let decoded = try? JSONDecoder().decode(RelationshipMessage.self, from: value) else {
                    print("Error in decoding")
                    return
                }
                
                switch decoded.type {
                    
                case "handshake":
                    print("HANDSHAKE BETWEEN DEVICES: \(decoded)")
                    //ADD CONNECTION
                    
                case "mpnotify":
                    isSendingData = false
                    isReceivingData = true
                    print("MPNTOIFICATION: \(decoded)")
                    isReceivingData = false
                    
                    guard let receiver = discoveredPeripherals.first(where: {
                        $0.name == decoded.to
                    }) else {
                        print("Coudln't find the \"from\" device")
                        return
                    }
                    
                    print("Attempting to connect....")
                    connect(to: receiver)
                    
                case "connection":
                    isReceivingData = true
                    print("Received connection message from \(decoded.from)")

                    guard let peer = discoveredPeripherals.first(where: { $0.name == decoded.from }) else {
                        print("Could not find peripheral named \(decoded.from)")
                        return
                    }
                    connect(to: peer)

                    #if os(iOS)
                    let message = "Confirmed connection: \(UIDevice.current.name)"
                        #elseif os(macOS)
                    let message = "Confirmed connection: Mac"
                    #endif
                    
                    #if os(iOS)
                    let fromString = UIDevice.current.name
                    #else
                    let fromString = "mac"
                    #endif
                    
                    let confirmMessage = RelationshipMessage(
                        message: message,
                        from: fromString,
                        to: decoded.from,
                        type: "confirmation",
                        isHandshakeRequired: false
                    )

                    if let confirmData = try? JSONEncoder().encode(confirmMessage),
                       let characteristic = clientSyncCharacteristics {
                        peripheralCore.updateValue(confirmData, for: characteristic, onSubscribedCentrals: nil)
                    }
                    
                default:
                    message = "Received from \(decoded.from): \(decoded.message)"
                    showMessage = true
                    
                }
            }
        }
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid == textCharacteristicsUUID,
           let value = request.value {
            
            guard let decoded = try? JSONDecoder().decode(RelationshipMessage.self, from: value) else {
                print("Error in decoding")
                return
            }
            
            switch decoded.type {
                
            case "handshake":
                print("HANDSHAKE BETWEEN DEVICES: \(decoded)")
                //ADD CONNECTION
                
            case "mpnotify":
                isSendingData = false
                isReceivingData = true
                print("MPNTOIFICATION: \(decoded)")
                isReceivingData = false
                
                guard let receiver = discoveredPeripherals.first(where: {
                    $0.name == decoded.to
                }) else {
                    print("Coudln't find the \"from\" device")
                    return
                }
                
                print("Attempting to connect....")
                connect(to: receiver)
                
                
            default:
                message = "Received from \(decoded.from): \(decoded.message)"
                showMessage = true
                
            }
            
            
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        if let error = error {
            print("Error in discovering services: \(error.localizedDescription)")
            return
        }
        
        if let services = peripheral.services {
            print("Discovered services:")
            for service in services {
                print("  \(service.uuid)")
                if service.uuid == textServiceUUID {
                    print("  Found matching service UUID")
                    peripheral.discoverCharacteristics([textCharacteristicsUUID], for: service)
                    return
                }
            }
            if !services.contains(where: { $0.uuid == textServiceUUID }) {
                print("  Service with UUID \(textServiceUUID) not found!, instead was: \(services.map({ $0.uuid}))")
            }
        }
    }
    
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard peripheral.state == .poweredOn else { return }
        
        if hierarchy == .client {
            clientSyncCharacteristics = CBMutableCharacteristic(
                type: textCharacteristicsUUID,
                properties: [.write,.notify],
                value: nil,
                permissions: .writeable
            )
            
            let service = CBMutableService(type: textServiceUUID, primary: true)
            service.characteristics = [clientSyncCharacteristics!]
            peripheralCore?.add(service)
            let filteredDevices: [String: Any] = [CBAdvertisementDataServiceUUIDsKey : [textServiceUUID]]
            peripheralCore.startAdvertising(filteredDevices)
        }
        
    }
    
}

extension GardenCore: @preconcurrency CBPeripheralDelegate {
}


public struct RelationshipMessage: Identifiable, Codable {
    
    public let id: UUID
    public let message: String
    public let from: String
    public let to: String
    
    public let type: String
    
    public let isHandshakeRequired: Bool
    
    init(id: UUID = UUID(), message: String, from: String, to: String, type: String = "message", isHandshakeRequired: Bool) {
        self.id = id
        self.message = message
        self.from = from
        self.to = to
        self.type = type
        self.isHandshakeRequired = isHandshakeRequired
    }
    
}

//MARK: Multipeer Extension

extension GardenCore: @preconcurrency MCSessionDelegate {
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("Connections")
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            self.message = "from: \(peerID), \(message)"
        }
    }
    
    @objc public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Received stream \(streamName) from \(peerID.displayName): \(stream)")
    }
    
    @objc public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Receiving resources \(resourceName) from \(peerID.displayName) at \(progress.completedUnitCount)")
    }
    
    @objc public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        if let error = error {
            print("Error in receiving resources stream \(resourceName) from \(peerID.displayName) with error: \(error.localizedDescription)")
        } else {
            print("Finished reeiving resources \(resourceName) from \(peerID.displayName) located at \(localURL)")
        }
    }
}
