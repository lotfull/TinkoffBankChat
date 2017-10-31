//
//  PeersService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IPeersService {
    func newChatsFetch(completionHandler: @escaping ((_ chats: [Chat]) -> ()))
}

protocol ConnectionManagerProtocol {
    var newChatsUpdate: ((_ chats: [Chat]) -> ())? { get set }
    var newMessagesUpdate: ((_ chats: [Chat]) -> ())? { get set }
    func sendMessage(string: String, to chat: Chat, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
}

class PeersService: IPeersService {
    
    var connectionManager: ConnectionManagerProtocol
    
    init(connectionManager: ConnectionManagerProtocol) {
        self.connectionManager = connectionManager
    }
    
    func newChatsFetch(completionHandler: @escaping (([Chat]) -> ())) {
        
        connectionManager.newChatsUpdate = {
            (chats: [Chat]) in
            completionHandler(chats)
            print("*** newChatsFetch chats.first \(chats.first?.name ?? "Nothing")")
        }
    }
}
