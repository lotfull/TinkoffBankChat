//
//  MultipeerService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol MultipeerServiceUpdateDelegate: class {
    func updateUI()
}

protocol MultipeerServiceDelegate: class {
    func didFindUser(userID: String, userName: String?)
    func didLoseUser(userID: String)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

protocol ConnectorDelegate: class {
    func didFindUser(userID: String, userName: String?)
    func didLoseUser(userID: String)
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class MultipeerService: ConnectorDelegate {
    
    weak var delegate: MultipeerServiceUpdateDelegate?
    weak var delegate1: MultipeerServiceDelegate?

    let multiPeerConnector: MultipeerConnector

    init(connector: MultipeerConnector) {
        self.multiPeerConnector = connector
        multiPeerConnector.delegate = self
    }
    
    func sendMessage(text: String, to chat: Chat) {
        let message = Message(text: text, date: Date(), type: .outbox)
        message.makeReaded()
        chat.messages.append(message)
        multiPeerConnector.sendMessage(string: text, to: chat.id, completionHandler: nil)
        delegate?.updateUI()
    }
    
    func communicationServices(enabled: Bool) {
        multiPeerConnector.online = enabled
    }
    
    // MARK: - ConnectorDelegate
    func didFindUser(userID: String, userName: String?) {
        delegate1?.didFindUser(userID: userID, userName: userName)
        delegate?.updateUI()
    }
    
    func didLoseUser(userID: String) {
        delegate1?.didLoseUser(userID: userID)
        delegate?.updateUI()
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        delegate1?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
        delegate?.updateUI()
    }
    
}
