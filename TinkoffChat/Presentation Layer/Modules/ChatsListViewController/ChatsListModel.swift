//
//  chatsListModel_.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

protocol IChatsListModel: class {
    weak var delegate: ChatsListDelegate? { get set }
    func newChatsFetch()
}

protocol ChatsListDelegate: class {
    func updateUI(with chats: [[Chat]])
}

class ChatsListModel: IChatsListModel, UITableViewDelegate, UITableViewDataSource {
    private let peersService: PeersService
    private let chatStorageService: IChatStorageService
    
    weak var delegate: ChatsListDelegate?
    private var tableView: UITableView!
    private var chatListFetchedResultsManager: ChatListFetchedResultsManager!
    private var fetchedResultsController: NSFetchedResultsController<Chat>

    init(peersService: PeersService) {
        self.peersService = peersService
    }
    
    func newChatsFetch() {
        peersService.newChatsFetch { (chats: [Chat]) in
            // TODO: - SORT FUNCTION
            self.delegate?.updateUI(with: self.sortForTableFormat(chats))
        }
    }
    
    func setup(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.register(nib, forCellReuseIdentifier: chatsTableViewCellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        chatListFetchedResultsManager = ChatListFetchedResultsManager(tableView: self.tableView)
        
    }
    
    private func sortForTableFormat(_ chats: [Chat]) -> [[Chat]] {
        var onlineChats1 = [Chat]()
        var onlineChats2 = [Chat]()
        var onlineChats3 = [Chat]()
        var offlineChats1 = [Chat]()
        var offlineChats2 = [Chat]()
        var offlineChats3 = [Chat]()
        for chat in chats {
            if chat.isOnline {
                if chat.lastMessageDate != nil {
                    onlineChats1.append(chat)
                } else {
                    if chat.name != nil {
                        onlineChats2.append(chat)
                    } else {
                        onlineChats3.append(chat)
                    }
                }
            } else {
                if chat.lastMessageDate != nil {
                    offlineChats1.append(chat)
                } else {
                    if chat.name != nil {
                        offlineChats2.append(chat)
                    } else {
                        offlineChats3.append(chat)
                    }
                }
            }
        }
        let answerChats = [
            onlineChats1.sorted { $0.lastMessageDate! > $1.lastMessageDate! } + onlineChats2.sorted { $0.name! > $1.name! } + onlineChats3,
            offlineChats1.sorted { $0.lastMessageDate! > $1.lastMessageDate! } + offlineChats2.sorted { $0.name! > $1.name! } + offlineChats3
        ]
        return answerChats
    }
    
    ///////////// ---- ////////////
    
    func chat(for indexPath: IndexPath) -> Chat {
        return chats[indexPath.section][indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
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
