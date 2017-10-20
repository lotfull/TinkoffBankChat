//
//  ConversationsTableViewCell.swift
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

class ConversationsTableViewCell: UITableViewCell {
    
    weak var cellDelegate: ConversationCellConfiguration?
    
    @IBOutlet weak var timeDateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
        if let message = cellDelegate!.message  {
            lastMessageLabel.text = message
            lastMessageLabel.font = cellDelegate!.hasUnreadMessages ? UIFont.boldSystemFont(ofSize: lastMessageLabel.font.pointSize) : UIFont.systemFont(ofSize: lastMessageLabel.font.pointSize)
        } else {
            lastMessageLabel.text = "No messages yet"
            lastMessageLabel.font = UIFont.init(name: "Times New Roman", size: lastMessageLabel.font.pointSize)
        }
        nameLabel.text = (cellDelegate!.name != nil) ? cellDelegate!.name! : "No Name Man"
        self.backgroundColor = cellDelegate!.online ? UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.15) : .white
        if let date = cellDelegate!.date {
            dateFormatter.dateFormat = NSCalendar.current.isDateInToday(date) ? "hh:mm" : "dd MMM"
            let dateString = dateFormatter.string(from:date)
            timeDateLabel.text = dateString
        } else {
            timeDateLabel.text = "undefined"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let dateFormatter = DateFormatter()

    
}
