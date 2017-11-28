//
//  InboxMessageCell.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
    var messageText: String? {get set}
}

class MessageCell: UITableViewCell, MessageCellConfiguration {
    
    var messageText: String? {
        didSet {
            messageLabel.text = messageText
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
}

enum MessageCellID: String {
    case inbox = "InboxCell"
    case outbox = "OutboxCell"
}
