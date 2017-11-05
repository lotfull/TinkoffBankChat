//
//  ChatsListViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 05.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ChatsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChatsListDelegate {
    
    var coreDataStack: CoreDataStack!
    
    // MARK: - ChatsListDelegate
    func updateUI(with chats: [[Chat]]) {
        DispatchQueue.main.async {
            self.chats = chats
            self.updateChatsList()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var model: IChatsListModel!
    var chats = [[Chat]]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func initWith(model: IChatsListModel) -> ChatsListViewController {
        let chatsListVC = UIStoryboard(name: "ChatsList", bundle: nil).instantiateViewController(withIdentifier: "ChatsListViewController") as! ChatsListViewController
        chatsListVC.model = model
        return chatsListVC
    }
    
//    private lazy var connectionManager: ConnectionManager = conManager()
//
//    func conManager() -> ConnectionManager {
//        let connectionManager = ConnectionManager(connector: MultipeerConnector())
//        connectionManager.delegate = self
//        connectionManager.communicationServices(enabled: true)
//        return connectionManager
//    }
    
    let chatsTableViewCellName = "ChatCell"
    let chatsTableViewCellID = "ChatCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: chatsTableViewCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: chatsTableViewCellID)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.newChatsFetch()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let chatVC = ChatAssembly().chatViewController()
        chatVC.chat = chat
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let chatVC = segue.destination as? ChatViewController,
//            let selectedIndexPath = tableView.indexPathForSelectedRow
////            , let selectedCell = tableView(tableView, cellForRowAt: selectedIndexPath) as? ChatCell
//        {
//            let selectedChat = chat(for: selectedIndexPath)
//            chatVC.chat = selectedChat
//            chatVC.navigationItem.title = selectedChat.name
//            chatVC.model = chatModel
////            chatVC.connectionManager = connectionManager
//            tableView.deselectRow(at: selectedIndexPath, animated: true)
//        }
//    }
    
    private func updateChatsList() {
        tableView.reloadData()
    }
    
    private let sectionName = ["Online", "History"]
}

extension ChatsListViewController {
    
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
