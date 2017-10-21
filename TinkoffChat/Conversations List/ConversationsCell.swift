//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 05.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration: class {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var message: String? {
        didSet {
            if message != nil {
                lastMessageLabel.font = .systemFont(ofSize: lastMessageLabel.font.pointSize)
                lastMessageLabel.text = message
            } else {
                lastMessageLabel.font = .italicSystemFont(ofSize: lastMessageLabel.font.pointSize)
                lastMessageLabel.text = noMessagesText
            }
        }
    }
    
    var date: Date? {
        didSet {
            if let date = self.date {
                if Calendar.current.compare(Date(), to: date, toGranularity: .day) == .orderedSame {
                    dateFormatter.dateFormat = "HH:mm"
                } else {
                    dateFormatter.dateFormat = "dd MMM"
                }
                timeDateLabel.text = dateFormatter.string(from: date)
            } else {
                timeDateLabel.text = ""
            }
        }
    }
    
    var online: Bool = false {
        didSet {
            backgroundColor = online ? onlineBackgroundColor : .white
        }
    }
    
    var hasUnreadMessages: Bool = false {
        didSet {
            if hasUnreadMessages {
                lastMessageLabel.font = .boldSystemFont(ofSize: lastMessageLabel.font.pointSize)
            } else if message != nil {
                lastMessageLabel.font = .systemFont(ofSize: lastMessageLabel.font.pointSize)
            }
        }
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    weak var cellDelegate: ConversationCellConfiguration?
    
    @IBOutlet weak var timeDateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let noMessagesText = "No messages yet"
    private let dateFormatter = DateFormatter()
    private let onlineBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.15)
    
}
