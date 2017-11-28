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
    
//    func assembly(_ chatViewController: ChatViewController, chatID: String) {
//        let model = chatModel(withChatID: chatID)
////        model.delegate = chatViewController
////        chatViewController.setDependencies(model)
//    }
    
    private func chatModel(withChat chat: Chat) -> ChatModel {
        return ChatModel(communicationService: RootAssembly.communicationService,
                         chatDataService: RootAssembly.chatDataService,
                         chat: chat)
    }

}
