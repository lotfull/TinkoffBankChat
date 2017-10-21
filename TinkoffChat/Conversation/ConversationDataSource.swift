//
//  ConversationDataSource.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 21.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ConversationDataSource: NSObject {
    
    struct CellIdentifier {
        static let inboxCellID = "InboxCell"
        static let outboxCellID = "OutboxCell"
    }
    
    let inboxCell = "InboxCell"
    let outboxCell = "OutboxCell"
    
    private let chat: Chat
    
    init(chat: Chat) {
        self.chat = chat
        super.init()
    }
}

extension ConversationDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chat.messages[indexPath.row]
        let identifier = message.type == .inbox ? CellIdentifier.inboxCellID : CellIdentifier.outboxCellID
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
        cell.messageText.text = message.text
        return cell
    }
}
