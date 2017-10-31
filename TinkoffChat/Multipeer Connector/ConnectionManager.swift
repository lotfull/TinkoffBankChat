//
//  ConnectionManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 24.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class ConnectionManager: ConnectorDelegate, ConnectionManagerProtocol {
    
    var newChatsUpdate: (([Chat]) -> ())?
    var newMessagesUpdate: (([Chat]) -> ())?
    
    func sendMessage(string: String, to chat: Chat, completionHandler: ((Bool, Error?) -> Void)?) {
        let message = Message(text: string, date: Date(), type: .outbox)
        message.makeReaded()
        chat.messages.append(message)
        multiPeerConnector.sendMessage(string: string, to: chat.id) { [weak self](success, error) in
            if success {
                self?.newMessagesUpdate?((self?.chats)!)
                self?.newChatsUpdate?((self?.chats)!)
                completionHandler!(success, nil)
            } else {
                completionHandler!(false, error)
            }
        }
    }
    
    
    weak var delegate: ConnectionManagerDelegate?
    
    private var multiPeerConnector = MultipeerConnector()
    var chats = [Chat]()
    
    init() {
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
    
//    func sendMessage(text: String, to chat: Chat) {
//        let message = Message(text: text, date: Date(), type: .outbox)
//        message.makeReaded()
//        chat.messages.append(message)
//        multiPeerConnector.sendMessage(string: text, to: chat.id, completionHandler: nil)
//        newMessagesUpdate(chats)
//        newChatsUpdate(chats)
//    }
    
    // MARK: - Connector Delegate
    func didFindUser(userID: String, userName: String?) {
        print("*** didFindUser userName \(userName ?? "No Name User") userID \(userID) ")
        if let chat = getChatFor(userID) {
            
            chat.isOnline = true
        } else {
            let chat = Chat(id: userID, name: userName, isOnline: true)
            chats.append(chat)
            print("*** didFindUser chats.first.name \(chats.first?.name ?? "Nothing")")
        }
        newChatsUpdate?(chats)
    }
    
    func didLoseUser(userID: String) {
        if let chat = getChatFor(userID) {
            chat.isOnline = false
        }
        newChatsUpdate?(chats)
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
            newMessagesUpdate?(chats)
            newChatsUpdate?(chats)
        }
    }
}
