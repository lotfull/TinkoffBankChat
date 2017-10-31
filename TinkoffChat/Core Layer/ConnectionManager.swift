//
//  ConnectionManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 24.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol ConnectionManagerProtocol: class {
    //func updateUI()
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    var chatsUpdate: ((_ chats: [Chat]) -> Void)? { get set }
    var messagesUpdate: ((_ messages: [Message]) -> Void)? { get set }
}

protocol ConnectorDelegate: class {
    func didFindUser(userID: String, userName: String?)
    func didLoseUser(userID: String)
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class ConnectionManager: ConnectionManagerProtocol, ConnectorDelegate {
    
    weak var delegate: ConnectionManagerDelegate_?
    
    let multiPeerConnector: MultipeerConnector
    var chats = [Chat]()
    
    init(connector: MultipeerConnector) {
        self.multiPeerConnector = connector
        multiPeerConnector.delegate = self
    }
    
    func getChatFor(_ id: String) -> Chat? {
        for chat in chats {
            if chat.id == id { return chat }
        }
        return nil
    }
    
    func getChats(online: Bool) -> [Chat] {
        return chats.filter { $0.isOnline == online }
    }
    
    func communicationServices(enabled: Bool) {
        multiPeerConnector.online = enabled
    }
    
    func sendMessage(text: String, to chat: Chat) {
        let message = Message(text: text, date: Date(), type: .outbox)
        message.makeReaded()
        chat.messages.append(message)
        multiPeerConnector.sendMessage(string: text, to: chat.id, completionHandler: nil)
        delegate?.updateUI()
    }
}

extension ConnectionManager: ConnectorDelegate {
    func didFindUser(userID: String, userName: String?) {
        if let chat = getChatFor(userID) {
            chat.isOnline = true
        } else {
            let chat = Chat(id: userID, name: userName, isOnline: true)
            chats.append(chat)
        }
        delegate?.updateUI()
    }
    
    func didLoseUser(userID: String) {
        if let chat = getChatFor(userID) {
            chat.isOnline = false
        }
        delegate?.updateUI()
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let chat = getChatFor(fromUser) {
            let message = Message(text: text, date: Date(), type: .inbox)
            chat.messages.append(message)
            delegate?.updateUI()
        }
    }
    
    
}
