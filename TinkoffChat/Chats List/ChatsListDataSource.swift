//
//  ChatsListDataSource.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 21.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ChatsListDataSource: NSObject {
    
    var chats = [[Chat]]()
    
    let connectionManager: ConnectionManager
    
    private let onlineHeader = "Online"
    private let historyHeader = "History"
    
    init(_ connectionManager: ConnectionManager) {
        self.connectionManager = connectionManager
        super.init()
        self.update()
    }
    
    func update() {
        let onlineChats = sort(connectionManager.getChats(online: true))
        let offlineChats = sort(connectionManager.getChats(online: false))
        chats = [onlineChats, offlineChats]
    }
    
    func chat(for indexPath: IndexPath) -> Chat {
        return chats[indexPath.section][indexPath.row]
    }
    
    private func sort(_ chats: [Chat]) -> [Chat] {
        var tempChats1 = [Chat]()
        var tempChats2 = [Chat]()
        var tempChats3 = [Chat]()
        for chat in chats {
            if chat.lastMessageDate != nil {
                tempChats1.append(chat)
            } else {
                if chat.name != nil {
                    tempChats2.append(chat)
                } else {
                    tempChats3.append(chat)
                }
            }
        }
        let answerChats = tempChats1.sorted { $0.lastMessageDate! > $1.lastMessageDate! } + tempChats2.sorted { $0.name! > $1.name! } + tempChats3
        return answerChats
    }
}

extension ChatsListDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? onlineHeader : historyHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
        
        let chat = self.chat(for: indexPath)
        chatCell.nameLabel.text = chat.name
        chatCell.message = chat.messages.last?.text
        chatCell.date = chat.lastMessageDate
        chatCell.online = chat.isOnline
        chatCell.hasUnreadMessages = chat.hasUnreadMessages
        return chatCell
    }
}

