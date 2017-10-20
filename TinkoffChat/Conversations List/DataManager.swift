//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol DataManagerDelegate: class {
    func didUpdate(_ onlineChats: [Chat], _ offlineChats: [Chat])
}

class DataManager {
    func getChats(online: Bool) -> [Chat] {
        return online ? Array(onlineChats.values) : Array(offlineChats.values)
    }
    
    weak var delegate: DataManagerDelegate?
    
    func Update(_ chat: Chat) {
        if chat.isOnline {
            onlineChats[chat.id] = chat
        } else {
            offlineChats[chat.id] = chat
        }
        delegate?.didUpdate(Array(onlineChats.values), Array(offlineChats.values))
    }
    
    let numberOfMessages = 6
    private lazy var offlineChats = generateChats(online: false)
    private lazy var onlineChats = generateChats(online: true)
    
    private let names = [
        "Freddie German",
        "Kara Cichon",
        "Flossie Rutherford",
        "Joyce Harding",
        "Willis Rakow",
        "Camila Richert",
        "Easter Christofferse",
        "Alanna Corker",
        "Lowell Branan",
        "Soila Hillard"
    ]

    let defaultText1 = "L"
    let defaultText30 = "Lorem ipsum dolor sit posuere."
    let defaultText300 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur et nunc ac lorem fringilla iaculis sed eget mauris. Nulla ut libero ac arcu facilisis faucibus ut id elit. Vivamus quam velit, vehicula vitae lobortis eu, maximus quis elit. Morbi ut nulla maximus mi condimentum tempor viverra fusce."
    
    private let standardMessages: [Message] = [
        Message(type: .inbox, text: defaultText1),
        Message(type: .inbox, text: defaultText30),
        Message(type: .inbox, text: defaultText300),
        Message(type: .outbox, text: defaultText1),
        Message(type: .outbox, text: defaultText30),
        Message(type: .outbox, text: defaultText300)
    ]
    
    func generateChats(online: Bool) -> [String: Chat] {
        var chats = [String: Chat]()
        for (i, name) in names.enumerated() {
            let hasUnreadMessages = arc4random_uniform(1) == 0
            let lastMessageDate = NSDate(timeIntervalSinceNow: TimeInterval(arc4random_uniform(234567)))
            let chat = Chat(id: String(i), name: name, messages: standardMessages, isOnline: online, hasUnreadMessages: hasUnreadMessages, lastMessageDate: lastMessageDate)
        }
        
    }
}
