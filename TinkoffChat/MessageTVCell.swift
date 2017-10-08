//
//  InboxMessageTVCell.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
    var text: String? {get set}
}

class MessageTVCell: UITableViewCell {
    
    weak var delegate: MessageCellConfiguration?

    @IBOutlet weak var messageText: UILabel!
    
    func configure() {
        messageText.text = delegate?.text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
