//
//  chatsListModel_.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IChatsListModelDelegate: class {
    func setup(dataSource: [[Chat]])
}

protocol IChatsListModel: class {
    
}

class ChatsListModel: IChatsListModel, MultipeerServiceDelegate {

    weak var delegate: IChatsListModelDelegate?
    
    let multipeerService: MultipeerService
    
    init(multipeerService: MultipeerService) {
        self.multipeerService = multipeerService
        print("ChatsListModel init")
    }
    
    private var chats = [Chat]()

    // MARK: - MultipeerServiceDelegate
    func didFindUser(userID: String, userName: String?) {
        if let chat = getChatFor(userID) {
            chat.isOnline = true
        } else {
            let chat = Chat(id: userID, name: userName, isOnline: true)
            chats.append(chat)
        }
        setupChatsToController()
    }
    
    func didLoseUser(userID: String) {
        if let chat = getChatFor(userID) {
            chat.isOnline = false
        }
        setupChatsToController()
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let chat = getChatFor(fromUser) {
            let message = Message(text: text, date: Date(), type: .inbox)
            chat.messages.append(message)
        }
        setupChatsToController()
    }
    
    // MARK: - helping funcs
    private func getChats(online: Bool) -> [Chat] {
        return chats.filter { $0.isOnline == online }
    }
    
    private func getChatFor(_ id: String) -> Chat? {
        for chat in chats {
            if chat.id == id { return chat }
        }
        return nil
    }
    private func setupChatsToController() {
        let onlineChats = sort(getChats(online: true))
        let offlineChats = sort(getChats(online: false))
        delegate?.setup(dataSource: [onlineChats, offlineChats])
    }
    
    private func sort(_ chats: [Chat]) -> [Chat] {
        var tempChats1 = [Chat]()
        var tempChats2 = [Chat]()
        var tempChats3 = [Chat]()
        for chat in chats {
            if chat.lastMessageDate != nil {
                tempChats1.append(chat)
            } else {
                if chat.name != nil {
                    tempChats2.append(chat)
                } else {
                    tempChats3.append(chat)
                }
            }
        }
        let answerChats = tempChats1.sorted { $0.lastMessageDate! > $1.lastMessageDate! } + tempChats2.sorted { $0.name! > $1.name! } + tempChats3
        return answerChats
    }
}
