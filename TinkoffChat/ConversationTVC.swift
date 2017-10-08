//
//  ConversationVC.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UITableViewController {

    let inboxMessageTVCellName = "InboxMessageTVCell"
    let outboxMessageTVCellName = "OutboxMessageTVCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = chat.name {
            self.title = name
        } else {
            self.title = "No Name Man"
        }
        let inboxNib = UINib(nibName: inboxMessageTVCellName, bundle: nil)
        tableView.register(inboxNib, forCellReuseIdentifier: inboxMessageTVCellName)
        let outboxNib = UINib(nibName: outboxMessageTVCellName, bundle: nil)
        tableView.register(outboxNib, forCellReuseIdentifier: outboxMessageTVCellName)
        
        let messagesFetchRequest = NSFetchRequest<Message>()
        messagesFetchRequest.entity = Message.entity()
        messagesFetchRequest.predicate = NSPredicate(format: "name = %@", "DefaultName")//chat.name!)
        do {
            messages = try managedObjectContext.fetch(messagesFetchRequest)
        } catch {
            fatalError("\(error)")
        }
    // MARK: - Table view data source
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].isInbox {
            let cell = tableView.dequeueReusableCell(withIdentifier: inboxMessageTVCellName, for: indexPath) as! InboxMessageTVCell
            cell.configure(withText: messages[indexPath.row].text)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: outboxMessageTVCellName, for: indexPath) as! OutboxMessageTVCell
            cell.configure(withText: messages[indexPath.row].text)
            return cell
        }
    }

    var messages: [Message]!
    var chat: Chat!
    var managedObjectContext: NSManagedObjectContext!
}
