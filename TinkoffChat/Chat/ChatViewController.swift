//
//  ChatVC.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chat: Chat!
    var dataManager: DataManager!
    private lazy var dataSource = ChatDataSource(chat: chat)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        tableView.dataSource = dataSource
        
    }
    
    func registerNibs() {
        let inboxNib = UINib(nibName: "InboxCell", bundle: nil)
        tableView.register(inboxNib, forCellReuseIdentifier: dataSource.inboxCell)
        let outboxNib = UINib(nibName: "OutboxCell", bundle: nil)
        tableView.register(outboxNib, forCellReuseIdentifier: dataSource.outboxCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chat.hasUnreadMessages = false
        dataManager.update(chat)
    }

}
