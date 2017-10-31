//
//  chatsListModel_.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IChatsListModel: class {
    weak var delegate: ConnectionManagerDelegate? { get set }
    func newChatsFetch()
}

protocol ConnectionManagerDelegate: class {
    func updateUI(with chats: [[Chat]])
}

class ChatsListModel: IChatsListModel {
    
    weak var delegate: ConnectionManagerDelegate?
    
    let peersService:
    PeersService
    
    init(peersService: PeersService) {
        self.peersService = peersService
    }
    
    func newChatsFetch() {
        peersService.newChatsFetch { (chats: [Chat]) in
            // TODO: - SORT FUNCTION
            self.delegate?.updateUI(with: self.sortForTableFormat(chats))
        }
    }
    
    private func sortForTableFormat(_ chats: [Chat]) -> [[Chat]] {
        var onlineChats1 = [Chat]()
        var onlineChats2 = [Chat]()
        var onlineChats3 = [Chat]()
        var offlineChats1 = [Chat]()
        var offlineChats2 = [Chat]()
        var offlineChats3 = [Chat]()
        for chat in chats {
            if chat.isOnline {
                if chat.lastMessageDate != nil {
                    onlineChats1.append(chat)
                } else {
                    if chat.name != nil {
                        onlineChats2.append(chat)
                    } else {
                        onlineChats3.append(chat)
                    }
                }
            } else {
                if chat.lastMessageDate != nil {
                    offlineChats1.append(chat)
                } else {
                    if chat.name != nil {
                        offlineChats2.append(chat)
                    } else {
                        offlineChats3.append(chat)
                    }
                }
            }
        }
        let answerChats = [
            onlineChats1.sorted { $0.lastMessageDate! > $1.lastMessageDate! } + onlineChats2.sorted { $0.name! > $1.name! } + onlineChats3,
            offlineChats1.sorted { $0.lastMessageDate! > $1.lastMessageDate! } + offlineChats2.sorted { $0.name! > $1.name! } + offlineChats3
        ]
        return answerChats
    }
    
    
}
