//
//  MultipeerConnector.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 24.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol Connector {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    weak var delegate: ConnectorDelegate? { get set }
    var online: Bool { get set }
}

protocol ConnectorDelegate: class {
    // discovering
    func didFindUser(userID: String, userName: String?)
    func didLoseUser(userID: String)
    
    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    // messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class MultipeerConnector: NSObject {
    weak var delegate: ConnectorDelegate?
    
    var online = false {
        didSet {
            online ? startServices() : stopServices()
        }
    }
    
    let serviceType = "tinkoff-chat"
    let userNameKey = "userName"
    let myPeerID = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
    let serviceBrowser: MCNearbyServiceBrowser
    let serviceAdvertiser: MCNearbyServiceAdvertiser
    
    var sessionsByPeerID = [MCPeerID: MCSession]()
    var invitedPeers = [MCPeerID: [String: String]?]()
    
    override init() {
        let discoveryInfo = [userNameKey: UIDevice.current.name]
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        super.init()
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
    }
    
    deinit {
        stopServices()
    }
    
    let messageEventTypeKey = "eventType"
    let messageEventTypeDescription = "TextMessage"
    let messageIdKey = "messageId"
    let messageTextKey = "text"
    
    func serializeMessageWith(_ text: String) throws -> Data  {
        let message = [messageEventTypeKey: messageEventTypeDescription,
                       messageIdKey: generateIdentifier(),
                       messageTextKey: text]
        return try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
    }
    
    func deserializeMessageFrom(_ data: Data) throws -> String? {
        let peerMessage =  try JSONSerialization.jsonObject(with: data, options:[] ) as? [String: String]
        return peerMessage?[messageTextKey]
    }
    
    func startServices() {
        serviceBrowser.startBrowsingForPeers()
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopServices() {
        serviceBrowser.stopBrowsingForPeers()
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func getSessionFor(_ peer: MCPeerID) -> MCSession {
        if sessionsByPeerID[peer] != nil {
            return sessionsByPeerID[peer]!
        }
        let session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessionsByPeerID[peer] = session
        return session
    }
    
    func getPeerIDFor(_ userID: String) -> MCPeerID? {
        for peerID in sessionsByPeerID.keys {
            if peerID.displayName == userID { return peerID }
        }
        return nil
    }
}

extension MultipeerConnector: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let session = getSessionFor(peerID)
        if session.connectedPeers.contains(peerID) == false {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
            invitedPeers[peerID] = info
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        sessionsByPeerID.removeValue(forKey: peerID)
        delegate?.didLoseUser(userID: peerID.displayName)
    }
}

extension MultipeerConnector: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let session = getSessionFor(peerID)
        let agreeInvitation = !session.connectedPeers.contains(peerID)
        invitationHandler(agreeInvitation, session)
    }
}

extension MultipeerConnector: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            if let invitedPeer = invitedPeers[peerID] {
                delegate?.didFindUser(userID: peerID.displayName, userName: invitedPeer?[userNameKey])
            }
        case .notConnected:
            sessionsByPeerID.removeValue(forKey: peerID)
            invitedPeers.removeValue(forKey: peerID)
            delegate?.didLoseUser(userID: peerID.displayName)
        case .connecting:
            print("CONNECTING")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            if let message = try deserializeMessageFrom(data) {
                delegate?.didReceiveMessage(text: message, fromUser: peerID.displayName, toUser: myPeerID.displayName)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
}

extension MultipeerConnector: Connector {
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        if let peerID = getPeerIDFor(userID),
            let session = sessionsByPeerID[peerID] {
            do {
                try session.send(serializeMessageWith(string),
                                 toPeers: [peerID], with: .reliable)
                completionHandler?(true, nil)
            } catch {
                completionHandler?(false, error)
            }
        }
    }
    
    
    
}




func generateIdentifier() -> String {
    return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
}
