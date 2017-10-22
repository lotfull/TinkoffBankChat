//
//  Message.swift
//  TinkoffConversation
//
//  Created by Kam Lotfull on 20.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

struct Message {
    enum MessageType {
        case inbox
        case outbox
    }
    let type: MessageType
    let text: String
}
