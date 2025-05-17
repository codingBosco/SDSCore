//
//  GardenCore.swift
//  SDSCore
//
//  Created by Sese on 24/04/25.
//

import Foundation
import MultipeerConnectivity
import NearbyInteraction
import UIKit
import SwiftUI


public struct GardenPeerError: Error {
    
}

public enum DeviceHierarchicalPosition: String, CaseIterable, Codable {
    
    case host
    case client
    
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
    private var deviceID: MCPeerID?
    
    public var showScanner = false
    
    
    ///A single string message
    public var message = ""
    
    ///Defines if the message is being showed in the UI
    public var showMessage = false
    
    ///A Boolean value for UI update whenever datas are being sended to the peers
    public var isSendingData = false
    
    ///A Boolean value for UI update whenever the device is receiving datas from other peers
    public var isReceivingData = false
    
    ///The session of the MultiPeerConnectivity Framework
    public var session: MCSession!
    
    public var connected: [MCPeerID] = []
    
    var advAssistant: MCAdvertiserAssistant!
    
    public func setupStart() {
        self.deviceID = MCPeerID(displayName: "\(UIDevice.current.name)_sds_device_\(UUID().uuidString.lowercased())")
        
        guard let deviceID else {
            return
        }
        
        self.session = MCSession(peer: deviceID, securityIdentity: nil, encryptionPreference: .required)
        self.session.delegate = self
        
        self.advAssistant = MCAdvertiserAssistant(serviceType: "sds-garden", discoveryInfo: nil, session: self.session)
        self.advAssistant.start()
    }
    
    public override init() {
        super.init()
        
      
            
        
    }
    
    func send(_ message: String) {
        if !self.session.connectedPeers.isEmpty {
            do {
                let data = message.data(using: .utf8)!
                try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
                print("\(message) inviato a tutti i peers")
            } catch {
                print("Errore nell'invio del messaggio: \(message), \(error)")
            }
        }
    }
    
    func startBrowsing() {
        let browser = MCBrowserViewController(serviceType: "sds-garden", session: self.session)
        browser.delegate = self
        
    }
    
}

extension GardenCore: @preconcurrency MCBrowserViewControllerDelegate {
    public func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    public func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
    
}

//MARK: Multipeer Extension

extension GardenCore: @preconcurrency MCSessionDelegate {
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .notConnected:
                self.connected.removeAll { $0 == peerID }
                print("\(peerID.displayName) disconnesso.")
            case .connecting:
                print("\(peerID.displayName) connecting....")
            case .connected:
                self.connected.append(peerID)
                print("\(peerID.displayName) connesso")
            @unknown default:
                fatalError("UNkwnon result for multipeer connectivity")
            }
        }
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
