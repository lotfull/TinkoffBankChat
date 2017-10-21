//
//  ConversationsListDataSource.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 21.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ConversationsListDataSource: NSObject {
    private var onlineChats: [Chat]
    private var offlineChats: [Chat]

    private let dataManager: DataManager
    
    private let online = "Online"
    private let history = "History"
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
        self.onlineChats = dataManager.getChats(online: true)
        self.offlineChats = dataManager.getChats(online: false)
        super.init()
        dataManager.delegate = self
    }
    
    func chat(for indexPath: IndexPath) -> Chat {
        return indexPath.section == 0 ? onlineChats[indexPath.row] : offlineChats[indexPath.row]
    }
}

extension ConversationsListDataSource: DataManagerDelegate {
    func didUpdate(_ onlineChats: [Chat], _ offlineChats: [Chat]) {
        self.onlineChats = onlineChats
        self.offlineChats = offlineChats
    }
}

extension ConversationsListDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? online : history
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? onlineChats.count : offlineChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as! ConversationCell
        
        let chat = self.chat(for: indexPath)
        chatCell.nameLabel.text = chat.name
        chatCell.message = chat.messages.last?.text
        chatCell.date = chat.lastMessageDate
        chatCell.online = chat.isOnline
        chatCell.hasUnreadMessages = chat.hasUnreadMessages
        return chatCell
    }
}

