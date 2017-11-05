//
//  Message.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

extension Message {
    let type: MessageType
    let text: String
    let date: Date
    var isRead = false

    init(text: String, date: Date, type: MessageType) {
        self.date = date
        self.text = text
        self.type = type
    }

    func makeReaded() {
        isRead = true
    }
}

enum MessageType {
    case inbox
    case outbox
}

