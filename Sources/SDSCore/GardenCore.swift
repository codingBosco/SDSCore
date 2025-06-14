//
//  GardenCore.swift
//  SDSCore
//
//  Created by Sese on 24/04/25.
//

import Foundation
import CoreBluetooth
import SwiftUI

@Observable
@MainActor
public final class GardenCore: NSObject {
    
    public enum CommunicationType {
        case ask
        case response
        case aknowlodgment
        
        public var threeWordType: String {
            switch self {
            case .ask:
                return "ASK"
            case .response:
                return "RSP"
            case .aknowlodgment:
                return "AKN"
            }
        }
    }
    
    
    #if os(iOS)
    
    public var nearbySession: NISession?
    public var researchingDiscoveryToken: NIDiscoveryToken?
    
    public var neabrySessionStarted = false
    
    public var isNearbySupported: Bool {
        NISession.deviceCapabilities.supportsDirectionMeasurement
    }
    
    func setupNearbySession() {
        
        guard isNearbySupported else {
            print("This device is not supported")
            return
        }
        
        nearbySession = NISession()
        nearbySession?.delegate = self
        
    }
    
    
    public func sendDiscoveryToken(as communicationType: CommunicationType) {
        guard let nearbySession else {
            print("Session not starded first!")
            return
        }
        
        guard let token = nearbySession.discoveryToken else {
            print("Sessions did not generated a discovery token")
            return
        }
        
        if let encodedToken = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) {
            send(message: "GARDEN_RESEARCH_\(communicationType.threeWordType)_\(encodedToken)")
        }
        
    }
    
    func startSession(with peerData: Data) {
        
        guard let researchingDiscoveryToken,
              let nearbySession else {
            print("Target Discovery Token or Session are nil")
            return
        }
         
        guard let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: peerData) else {
            print("Error in peerData (discovery token encoded) reading")
            return
        }
        
        let configuration = NINearbyPeerConfiguration(peerToken: token)
        nearbySession.run(configuration)
        
    }
    
    #endif
    

    
    
    let serviceUUID = CBUUID(string: "78d36318-f0e0-422b-8dd6-2f71cc3c7a10")
    let characteristicUUID = CBUUID(string: "51a6899c-f71a-4593-a331-6e3d3d53c012")
    private var transferCharacteristic: CBMutableCharacteristic?


    public var message = ""
    public var showMessage = false
    public var isSendingData = false
    public var isReceivingData = false
    public var connectionStatus: String = "Disconnected"


    private var centralManager: CBCentralManager!
    private var peripheralManager: CBPeripheralManager!

    public var discoveredPeripherals: [CBPeripheral] = []
    public var connectedPeripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?
    public var subscribedCentrals: [CBCentral] = []



    private var receivedDataBuffer = Data()
    private let eomData = "EOM".data(using: .utf8)!

    public override init() {
        super.init()
    }

    public func setup() {
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        print("GardenCore setup initiated.")
    }

    // MARK: - Modalità Central (Scanner e Connettore)

    public func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Central Manager not powered on. Current state: \(centralManager.state.rawValue)")
            connectionStatus = "Bluetooth Off"
            return
        }
        print("Starting scan for peripherals with service: \(serviceUUID.uuidString)")
        connectionStatus = "Scanning..."
        discoveredPeripherals.removeAll() // Pulisci la lista precedente
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }

    public func stopScanning() {
        if centralManager.isScanning {
            print("Stopping scan.")
            centralManager.stopScan()
            if connectionStatus == "Scanning..." {
                connectionStatus = "Scan stopped"
            }
        }
    }

    public func connect(to peripheral: CBPeripheral) {
        guard centralManager.state == .poweredOn else {
            print("Cannot connect: Central Manager not powered on.")
            return
        }
        if connectedPeripheral != nil && connectedPeripheral != peripheral {
            print("Already connected to another peripheral. Disconnecting first.")
            disconnectPeripheral()
        }
        
        print("Attempting to connect to peripheral: \(peripheral.name ?? "Unknown") (\(peripheral.identifier.uuidString))")
        connectionStatus = "Connecting to \(peripheral.name ?? "device")..."
        centralManager.connect(peripheral, options: nil)
    }

    public func disconnectPeripheral() {
        if let peripheral = connectedPeripheral {
            print("Disconnecting from peripheral: \(peripheral.name ?? "Unknown")")
            centralManager.cancelPeripheralConnection(peripheral)
        } else {
            print("No peripheral connected to disconnect.")
        }
    }

    // MARK: - Modalità Peripheral (Advertiser)

    public func setupPeripheralService() {
        guard peripheralManager.state == .poweredOn else {
            print("Peripheral Manager not powered on. Cannot setup service.")
            return
        }

        // Rimuovi vecchi servizi se presenti (buona pratica durante lo sviluppo)
        peripheralManager.removeAllServices()

        let mutableCharacteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: [.read, .write, .notify], // Scegli le proprietà necessarie
            value: nil,
            permissions: [.readable, .writeable] // Scegli i permessi necessari
        )
        self.transferCharacteristic = mutableCharacteristic // Salva la caratteristica per uso futuro

        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [mutableCharacteristic]

        peripheralManager.add(service)
        print("Service and characteristic defined for peripheral.")
    }

    public func startAdvertising() {
        guard peripheralManager.state == .poweredOn else {
            print("Peripheral Manager not powered on. Cannot start advertising.")
            // Potresti mettere in coda l'advertising per quando sarà poweredOn
            return
        }
        
        
        if self.transferCharacteristic == nil {
             setupPeripheralService()
             
             return
        }

#if os(iOS)
        let deviceName = UIDevice.current.name.prefix(10)
        #elseif os(macOS)
        let deviceName = "mac"
        #endif

        if !peripheralManager.isAdvertising {
            print("Starting advertising with service UUID: \(serviceUUID.uuidString)")
            peripheralManager.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
               
                CBAdvertisementDataLocalNameKey: "GardenDevice-\(deviceName)"
            ])
        } else {
            print("Peripheral is already advertising.")
        }
    }

    public func stopAdvertising() {
        if peripheralManager.isAdvertising {
            print("Stopping advertising.")
            peripheralManager.stopAdvertising()
        }
    }

    // MARK: - Data Transfer

    public func send(message: String) {
        guard let data = message.data(using: .utf8) else {
            print("Error: Could not convert message to Data.")
            return
        }


        if let peripheral = connectedPeripheral, let char = writeCharacteristic {
            print("Sending message as Central: \(message)")
            
            peripheral.writeValue(data, for: char, type: .withResponse)
            peripheral.writeValue(eomData, for: char, type: .withResponse)
            isSendingData = true
        }
       
        
        else if !subscribedCentrals.isEmpty, let char = self.transferCharacteristic {
            print("Sending message as Peripheral to \(subscribedCentrals.count) central(s): \(message)")
            var success = peripheralManager.updateValue(data, for: char, onSubscribedCentrals: nil)
            if !success {
                print("Failed to send initial data packet as peripheral.")
            }
            
            success = peripheralManager.updateValue(eomData, for: char, onSubscribedCentrals: nil)
            if !success { print("Failed to send EOM as peripheral. Sended to \(connectedPeripheral?.name)") }
            isSendingData = true
        } else {
            print("Cannot send message: No connected peripheral or subscribed central, or characteristic not ready.")
            self.message = "Error: Not connected to send."
            self.showMessage = true
        }
    }
    
    private func handleReceivedData(_ data: Data) {

        receivedDataBuffer.append(data)

        
        if let eomRange = receivedDataBuffer.range(of: eomData) {
            let messageData = receivedDataBuffer.subdata(in: receivedDataBuffer.startIndex..<eomRange.lowerBound)
            if let receivedString = String(data: messageData, encoding: .utf8) {
                print("Message received: \(receivedString)")
                
                message = receivedString
                
                #if os(iOS)
                if receivedString.contains("GARDEN_RESEARCH") && !neabrySessionStarted {
                    let nearbySessionComponents = receivedString.split(separator: "_")
                        
                        //Devi rispondere inviando il codice
                        self.sendDiscoveryToken(as: .response)
                        
                    
                    //E setta il codice
                    guard let tokenComponent = nearbySessionComponents[3].data(using: .utf8) else {
                        print("Error in encoding data")
                        return
                    }
                    self.setupNearbySession()
                    self.startSession(with: tokenComponent)
                        
                    self.neabrySessionStarted = true
                    
                }
                #endif
                
                DispatchQueue.main.async {
                    self.isReceivingData = false
                }
            } else {
                print("Error: Could not decode received data to string.")
            }
            
            receivedDataBuffer.removeSubrange(receivedDataBuffer.startIndex...eomRange.upperBound - 1)
        } else {
           
            print("Received data chunk, waiting for EOM. Buffer size: \(receivedDataBuffer.count)")
            DispatchQueue.main.async {
                self.isReceivingData = true // Aggiorna UI
            }
        }
    }
    
    
#if os(iOS)
    public var receivedDiscoveryToken : NIDiscoveryToken?
    
    public func startPhysicalSearch() {
        if NISession.deviceCapabilities.supportsDirectionMeasurement {
            print("Support Distance")
        } else if NISession.deviceCapabilities.supportsPreciseDistanceMeasurement {
            print("Support Precise DIstance")
        }
        
        guard let token = receivedDiscoveryToken else {
            print("Error")
            return
        }
        
        let config = NINearbyPeerConfiguration(peerToken: token)
        
    }
    #endif
    
}

// MARK: - CBCentralManagerDelegate
extension GardenCore: @preconcurrency CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            connectionStatus = "Ready to scan"
            
        case .poweredOff:
            connectionStatus = "Error: Bluetooth Off"
            discoveredPeripherals.removeAll()
            connectedPeripheral = nil
        case .unsupported:
            print("Central Manager is unsupported.")
            connectionStatus = "Error: Bluetooth Unsupported"
        case .unauthorized:
            connectionStatus = "Error: Bluetooth Unauthorized"
        case .resetting:
            connectionStatus = "Error: Bluetooth Resetting"
        case .unknown:
            connectionStatus = "Error: Bluetooth Unknown State"
        @unknown default:
            fatalError("Unknown CBCentralManager state")
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredPeripherals.append(peripheral)
        }
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectionStatus = "Connected to \(peripheral.name ?? "device")"
        connectedPeripheral = peripheral
        peripheral.delegate = self
        

        peripheral.discoverServices([serviceUUID])
        
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral: \(peripheral.name ?? "Unknown"). Error: \(error?.localizedDescription ?? "None")")
        connectionStatus = "Connessione Fallita, \(error?.localizedDescription )"
        if connectedPeripheral?.identifier == peripheral.identifier {
            connectedPeripheral = nil
        }
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectionStatus = "Disconnesso da \(peripheral.name ?? "Unknown"). Errore: \(error?.localizedDescription ?? "None")"
        if connectedPeripheral?.identifier == peripheral.identifier {
            connectedPeripheral = nil
            writeCharacteristic = nil
        }
    }
    
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("Central Manager will restore state with: \(dict)")

    }
}

// MARK: - CBPeripheralManagerDelegate
extension GardenCore: @preconcurrency CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheralManager: CBPeripheralManager) {
        switch peripheralManager.state {
        case .poweredOn:
            print("Peripheral Manager is powered on.")
            // Ora puoi aggiungere il servizio e iniziare l'advertising
            setupPeripheralService()
        case .poweredOff:
            print("Peripheral Manager is powered off.")
            stopAdvertising()
        case .unsupported:
            print("Peripheral Manager is unsupported.")
        case .unauthorized:
            print("Peripheral Manager is unauthorized.")
        case .resetting:
            print("Peripheral Manager is resetting.")
        case .unknown:
            print("Peripheral Manager state is unknown.")
        @unknown default:
            fatalError("Unknown CBPeripheralManager state")
        }
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("Error adding service: \(error.localizedDescription)")
            return
        }
        print("Service added successfully. UUID: \(service.uuid.uuidString)")
            startAdvertising()
        
    }

    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Error starting advertising: \(error.localizedDescription)")
            return
        }
        print("Peripheral started advertising successfully.")
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Central \(central.identifier.uuidString) subscribed to characteristic \(characteristic.uuid.uuidString), ")
        if !subscribedCentrals.contains(central) {
            subscribedCentrals.append(central)
        }
        
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Central \(central.identifier.uuidString) unsubscribed from characteristic \(characteristic.uuid.uuidString)")
        subscribedCentrals.removeAll { $0.identifier == central.identifier }
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("Received read request for characteristic \(request.characteristic.uuid.uuidString) from central \(request.central.identifier.uuidString)")
        
        guard request.characteristic.uuid == self.characteristicUUID else {
            peripheral.respond(to: request, withResult: .attributeNotFound)
            return
        }

        if let value = self.transferCharacteristic?.value, request.offset < value.count {
             request.value = value.subdata(in: request.offset..<value.count)
             peripheral.respond(to: request, withResult: .success)
        } else {
             request.value = Data() // O nil, a seconda di come vuoi gestire offset non validi
             peripheral.respond(to: request, withResult: .success) // O .invalidOffset
        }
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("Received \(requests.count) write request(s).")
        for request in requests {
            print("Write request for char \(request.characteristic.uuid.uuidString) from central \(request.central.identifier.uuidString) with data: \(String(data: request.value ?? Data(), encoding: .utf8) ?? "nil")")
            guard request.characteristic.uuid == self.characteristicUUID else {
                print("Write to incorrect characteristic UUID: \(request.characteristic.uuid)")
                
                continue
            }

            if let data = request.value {
                
                handleReceivedData(data)
            }
        }

        peripheral.respond(to: requests.first!, withResult: .success)
    }
    
    public func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        print("Peripheral manager is ready to update subscribers again.")
        
        isSendingData = false
    }
}

// MARK: - CBPeripheralDelegate (per il Central quando interagisce con un Peripheral connesso)
extension GardenCore: @preconcurrency CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services for peripheral \(peripheral.name ?? "Unknown"): \(error.localizedDescription)")
            disconnectPeripheral()
            return
        }

        guard let services = peripheral.services else {
            print("No services found for peripheral \(peripheral.name ?? "Unknown").")
            disconnectPeripheral()
            return
        }

        print("Discovered \(services.count) services for peripheral \(peripheral.name ?? "Unknown").")
        for service in services {
            print("Service UUID: \(service.uuid.uuidString)")
            if service.uuid == serviceUUID {
                print("Found our service. Discovering characteristics...")
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
                return
            }
        }
        print("Our specific service UUID (\(serviceUUID.uuidString)) not found on peripheral \(peripheral.name ?? "Unknown").")
        disconnectPeripheral()
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics for service \(service.uuid.uuidString) on peripheral \(peripheral.name ?? "Unknown"): \(error.localizedDescription)")
            disconnectPeripheral()
            return
        }

        guard let characteristics = service.characteristics else {
            print("No characteristics found for service \(service.uuid.uuidString) on peripheral \(peripheral.name ?? "Unknown").")
            disconnectPeripheral()
            return
        }

        print("Discovered \(characteristics.count) characteristics for service \(service.uuid.uuidString).")
        for characteristic in characteristics {
            print("Characteristic UUID: \(characteristic.uuid.uuidString), Properties: \(characteristic.properties.rawValue)")
            if characteristic.uuid == characteristicUUID {
                print("Found our characteristic. Properties: \(characteristic.properties)")
                
               
                if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                    self.writeCharacteristic = characteristic
                    print("Characteristic saved for writing.")
                }
                
                
                if characteristic.properties.contains(.notify) {
                    print("Subscribing to notifications for characteristic...")
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                
                
                if characteristic.properties.contains(.read) {
                    print("Reading initial value for characteristic...")
                    peripheral.readValue(for: characteristic)
                }
                
                connectionStatus = "Ready to chat with \(peripheral.name ?? "device")"
                return
            }
        }
        print("Our specific characteristic UUID (\(characteristicUUID.uuidString)) not found for service \(service.uuid.uuidString) on peripheral \(peripheral.name ?? "Unknown").")
        disconnectPeripheral()
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic \(characteristic.uuid.uuidString): \(error.localizedDescription)")
            return
        }

        guard let data = characteristic.value else {
            print("Characteristic \(characteristic.uuid.uuidString) value is nil.")
            return
        }
        
        print("Received data on characteristic \(characteristic.uuid.uuidString): \(String(data: data, encoding: .utf8) ?? "raw bytes: \(data.count)")")
        handleReceivedData(data)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing value to characteristic \(characteristic.uuid.uuidString): \(error.localizedDescription)")
            
            DispatchQueue.main.async {
                self.message = "Failed to send: \(error.localizedDescription)"

            }
            return
        }
        print("Successfully wrote value to characteristic \(characteristic.uuid.uuidString).")

        DispatchQueue.main.async {
             if self.isSendingData {
                 self.isSendingData = false
                 
             }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error changing notification state for characteristic \(characteristic.uuid.uuidString): \(error.localizedDescription)")
            return
        }

        if characteristic.isNotifying {
            print("Successfully subscribed to notifications for characteristic \(characteristic.uuid.uuidString).")
        } else {
            print("Successfully unsubscribed from notifications for characteristic \(characteristic.uuid.uuidString).")
            // Potrebbe essere necessario gestire la disconnessione o la pulizia qui se l'unsubscription non è intenzionale
        }
    }
    
    public func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        print("Peripheral \(peripheral.name ?? "Unknown") is ready to send write without response again.")
        // Simile a peripheralManagerIsReady(toUpdateSubscribers:), usato quando si inviano
        // grandi quantità di dati con .writeWithoutResponse.
        // sendNextChunkOfData()
        DispatchQueue.main.async {
            self.isSendingData = false
        }
    }
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

public enum GardenPeerError: Error {
    
    case invalidConnection
    case sendingError(String)
    case error(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidConnection:
            return "Invalid connection attempt"
        case .error(let error):
            return "Error in GardenCoreRuntime: \(error)"
        case .sendingError(let description):
            return "Error in sending the message to the connected peer with error: \(description)"
        }
    }
    
}

#if os(iOS)
import NearbyInteraction

extension GardenCore: @preconcurrency NISessionDelegate {
    
    public func sessionDidStartRunning(_ session: NISession) {
        print("Nearby Session Started")
    }
    
    public func sessionWasSuspended(_ session: NISession) {
        print("Nearby Session Suspended!")
    }
    
    public func sessionSuspensionEnded(_ session: NISession) {
        print("Nearby Session Ended")
    }
    
    public func session(_ session: NISession, didInvalidateWith error: any Error) {
        print("Nearby Session invalidated with error: \(error)")
    }
    
    public func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        print("NSession Updated: -to nearby objects \(nearbyObjects.count)")
    }
    
    public func session(_ session: NISession, didGenerateShareableConfigurationData shareableConfigurationData: Data, for object: NINearbyObject) {
        print("Nearby Generated sharable config data for \(object)")
    }
    
    
    public func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        for nearbyObject in nearbyObjects {
            print("Nearby Session removed \(nearbyObject.discoveryToken) for: \(reason)")
        }
    }
    
    public func session(_ session: NISession, didUpdateAlgorithmConvergence convergence: NIAlgorithmConvergence, for object: NINearbyObject?) {
        print("Updated Convergance Algortihm: \(convergence) for \(object)")
    }
    

}
#endif
