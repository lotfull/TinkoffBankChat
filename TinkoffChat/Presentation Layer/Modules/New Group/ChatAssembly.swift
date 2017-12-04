//
//  ChatAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class ChatAssembly {
    
    func chatViewController(withChat chat: Chat) -> ChatViewController {
        let model = chatModel(withChat: chat)
        let chatVC = ChatViewController.initWith(model: model)
        model.delegate = chatVC
        return chatVC
    }
    
    private func chatModel(withChat chat: Chat) -> ChatModel {
        return ChatModel(communicationService: RootAssembly.communicationService,
                         chatDataService: RootAssembly.chatDataService,
                         chat: chat)
    }

}
