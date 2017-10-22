//
//  Conversation.swift
//  TinkoffConversation
//
//  Created by Kam Lotfull on 20.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    var messages: [Message]
    var isOnline: Bool
    var hasUnreadMessages: Bool
    var lastMessageDate: Date?
}
