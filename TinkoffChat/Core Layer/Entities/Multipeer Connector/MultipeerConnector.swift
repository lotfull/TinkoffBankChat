//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 24.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicator {
    func sendMessage(string: String, to userID: String, completion: ((_ success: Bool, _ error: Error?) -> Void)?)
    weak var delegate: ICommunicatorDelegate? { get set }
    var online: Bool { get set }
}

protocol ICommunicatorDelegate: class {
    func didFindUser(userID: String, userName: String?)
    func didLoseUser(userID: String)
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class MultipeerCommunicator: NSObject {
    weak var delegate: ICommunicatorDelegate?
    
    var online = false {
        didSet {
            online ? startServices() : stopServices()
        }
    }
    
    let serviceType = "tinkoff-chat"
    let userNameKey = "userName"
    let myPeerID = MCPeerID(displayName: UIDevice.current.name + "=" +  UIDevice.current.identifierForVendor!.uuidString)
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
        startServices()
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
        print("*** startServices")
        serviceBrowser.startBrowsingForPeers()
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopServices() {
        print("*** stopServices")
        serviceBrowser.stopBrowsingForPeers()
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func getSessionFor(_ peerID: MCPeerID) -> MCSession {
        if sessionsByPeerID[peerID] != nil {
            print("*** session already exists for peerID \(peerID.displayName)")
            return sessionsByPeerID[peerID]!
        }
        print("*** session new created for peerID \(peerID.displayName)")
        let session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessionsByPeerID[peerID] = session
        return session
    }
    
    func getPeerIDFor(_ userID: String) -> MCPeerID? {
        for peerID in sessionsByPeerID.keys {
            if peerID.displayName == userID {
                return peerID
            }
        }
        return nil
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("*** peerID found \(peerID.displayName)")
        let session = getSessionFor(peerID)
        print(session.connectedPeers)
        if invitedPeers[peerID] == nil {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
            print("*** peerID invited \(peerID.displayName)")
            invitedPeers[peerID] = info
        } else {
            print("*** peerID already in connectedPeers \(peerID.displayName)\n*** invitedPeers[peerID] = \(invitedPeers[peerID])")
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("*** peerID lost \(peerID.displayName)")
        let session_ = getSessionFor(peerID)
        sessionsByPeerID.removeValue(forKey: peerID)
        session(session_, peer: peerID, didChange: .notConnected)
//        let indexOfPeerID = session.connectedPeers.index(of: peerID)
//        session.connectedPeers.remove(at: indexOfPeerID)
        invitedPeers.removeValue(forKey: peerID)
        delegate?.didLoseUser(userID: peerID.displayName)
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("*** didReceiveInvitationFromPeer \(peerID.displayName)")
        let session = getSessionFor(peerID)
        let agreeInvitation = !session.connectedPeers.contains(peerID)
        invitationHandler(agreeInvitation, session)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("*** peerID session \(state.rawValue) CONNECTED with peer \(peerID.displayName)")
            if let invitedPeer = invitedPeers[peerID] {
                delegate?.didFindUser(userID: peerID.displayName, userName: invitedPeer?[userNameKey])
            }
        case .notConnected:
            print("*** peerID session \(state.rawValue) NOT CONNECTED with peer \(peerID.displayName)")
            sessionsByPeerID.removeValue(forKey: peerID)
            invitedPeers.removeValue(forKey: peerID)
            delegate?.didLoseUser(userID: peerID.displayName)
        case .connecting:
            print("*** peerID session \(state.rawValue) CONNECTING with peer \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("*** didReceive DATA from peer \(peerID.displayName)")
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

extension MultipeerCommunicator: ICommunicator {
    func sendMessage(string: String, to userID: String, completion: ((Bool, Error?) -> Void)?) {
        if let peerID = getPeerIDFor(userID),
            let session = sessionsByPeerID[peerID] {
            do {
                try session.send(serializeMessageWith(string),
                                 toPeers: [peerID], with: .reliable)
                completion?(true, nil)
            } catch {
                completion?(false, error)
            }
        }
    }
}

func generateIdentifier() -> String {
    return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
}
