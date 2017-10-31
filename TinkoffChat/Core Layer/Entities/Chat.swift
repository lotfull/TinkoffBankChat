//
//  Chat.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class Chat {
    let id: String
    var name: String?
    var messages = [Message]()
    var isOnline: Bool
    var hasUnreadMessages: Bool {
        return messages.last?.isRead ?? false
    }
    var lastMessageDate: Date? {
        return messages.last?.date
    }
    
    init(id: String, name: String?, isOnline: Bool) {
        self.id = id
        self.name = name ?? "Unnamed"
        self.isOnline = isOnline
    }
}
