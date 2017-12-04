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
    var messageDate: Date? {get set}
}

class MessageCell: UITableViewCell, MessageCellConfiguration {
    
    override func awakeFromNib() {
        messageFrame.layer.cornerRadius = 15
    }
    
    var messageText: String? {
        didSet {
            messageTextLabel.text = messageText
        }
    }
    
    var messageDate: Date? {
        didSet {
            messageTimeLabel.text = MessageCell.dateFormatter.string(from: messageDate!)
        }
    }
    
    @IBOutlet weak var messageFrame: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
}

extension MessageCell {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

enum MessageCellID: String {
    case inbox = "InboxCell"
    case outbox = "OutboxCell"
}
