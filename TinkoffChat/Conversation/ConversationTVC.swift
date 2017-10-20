//
//  ConversationVC.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UITableViewController, MessageCellConfiguration {

    let inboxMessageCellName = "InboxMessageCell"
    let outboxMessageCellName = "OutboxMessageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = chat.name
        let inboxNib = UINib(nibName: inboxMessageCellName, bundle: nil)
        tableView.register(inboxNib, forCellReuseIdentifier: inboxMessageCellName)
        let outboxNib = UINib(nibName: outboxMessageCellName, bundle: nil)
        tableView.register(outboxNib, forCellReuseIdentifier: outboxMessageCellName)
        
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        text = messages[indexPath.row].text
        if messages[indexPath.row].type == .inbox {
            let cell = tableView.dequeueReusableCell(withIdentifier: inboxMessageCellName, for: indexPath) as! MessageCell
            cell.delegate = self
            cell.configure()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: outboxMessageCellName, for: indexPath) as! MessageCell
            cell.delegate = self
            cell.configure()
            return cell
        }
    }

    var text: String?
    var messages: [Message]!
    var chat: Chat!
    var managedObjectContext: NSManagedObjectContext!
}
