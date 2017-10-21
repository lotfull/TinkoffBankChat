//
//  ConversationVC.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chat: Chat!
    var dataManager: DataManager!
    private lazy var dataSource = ConversationDataSource(chat: chat)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register xib
        let inboxNib = UINib(nibName: "InboxCell", bundle: nil)
        tableView.register(inboxNib, forCellReuseIdentifier: dataSource.inboxCell)
        let outboxNib = UINib(nibName: "OutboxCell", bundle: nil)
        tableView.register(outboxNib, forCellReuseIdentifier: dataSource.outboxCell)
        
        tableView.dataSource = dataSource
        
//        let messagesFetchRequest = NSFetchRequest<Message>()
//        messagesFetchRequest.entity = Message.entity()
//        messagesFetchRequest.predicate = NSPredicate(format: "name = %@", "DefaultName")//chat.name!)
//        do {
//            messages = try managedObjectContext.fetch(messagesFetchRequest)
//        } catch {
//            fatalError("\(error)")
//        }
    // MARK: - Table view data source
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chat.hasUnreadMessages = false
        dataManager.update(chat)
    }

}
