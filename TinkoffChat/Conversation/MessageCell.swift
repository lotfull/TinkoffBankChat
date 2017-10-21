//
//  InboxMessageCell.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
    var text: String? {get set}
}

class MessageCell: UITableViewCell {
    
    weak var delegate: MessageCellConfiguration?

    @IBOutlet weak var messageText: UILabel!
    
    func configure() {
        messageText.text = delegate?.text
    }
}
