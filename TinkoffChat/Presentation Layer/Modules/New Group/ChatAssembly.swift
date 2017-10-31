//
//  ChatAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class ChatAssembly {
    func chatViewController() -> ChatViewController {
        let model = chatModel()
        let chatVC = ChatViewController.initWith(model: model)
        model.delegate = chatVC
        return chatVC
    }
    
    private func chatModel() -> IChatModel {
        return ChatModel(messagesService: messagesService())
    }
    
    private func messagesService() -> MessagesService {
        return MessagesService(connectionManager: RootAssembly.connectionManager)
    }
}
