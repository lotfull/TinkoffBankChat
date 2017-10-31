//
//  ChatModel.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IChatModel: class {
    weak var delegate: ChatMessagesDelegate? { get set }
    func newMessagesFetch()
    func sendMessage(string: String, to chat: Chat, completionHandler: ((Bool, Error?) -> Void)?)
}

protocol ChatMessagesDelegate: class {
    func updateUI(with chat: Chat)
}

class ChatModel: IChatModel {
    
    weak var delegate: ChatMessagesDelegate?
    
    let messagesService: MessagesService
    
    init(messagesService: MessagesService) {
        self.messagesService = messagesService
    }
    
    func newMessagesFetch() {
        messagesService.newMessagesFetch { (chat: Chat) in
            self.delegate?.updateUI(with: chat)
        }
    }
    
    func sendMessage(string: String, to chat: Chat, completionHandler: ((Bool, Error?) -> Void)?) {
        messagesService.sendMessage(string: string, to: chat, completionHandler: completionHandler)
    }
    
}
