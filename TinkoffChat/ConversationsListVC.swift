//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 05.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UITableViewController, ConversationCellConfiguration {
    
    var name: String?
    var message: String?
    var date: Date?
    var online = false
    var hasUnreadMessages = false
    let conversationsTableViewCellName = "ConversationsTableViewCell"
    let conversationsTableViewCellID = "ConversationsTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: conversationsTableViewCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: conversationsTableViewCellID)
        let chatsFetchRequest = NSFetchRequest<Chat>()
        chatsFetchRequest.entity = Chat.entity()
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
        chatsFetchRequest.sortDescriptors = [sortDescriptor1]
        do {
            chats = try managedObjectContext.fetch(chatsFetchRequest)
        } catch {
            fatalError("\(error)")
        }
        onlineChats = chats.filter({ (chat:Chat) -> Bool in
            return chat.online
        })
        historyChats = chats.filter({ (chat:Chat) -> Bool in
            return chat.message != nil && !chat.online
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        default:
            return "History"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return onlineChats.count
        case 1:
            return historyChats.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var chat: Chat!
        switch indexPath.section {
        case 0:
            chat = onlineChats[indexPath.row]
        case 1:
            chat = historyChats[indexPath.row]
        default:
            print("error num of section")
        }
        name = chat.name
        message = chat.message
        date = chat.date as Date?
        online = chat.online
        hasUnreadMessages = chat.hasUnreadMessages
        let cell = tableView.dequeueReusableCell(withIdentifier: conversationsTableViewCellID, for: indexPath) as! ConversationsTableViewCell
        cell.cellDelegate = self
        cell.configure()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChat = indexPath.section == 0 ? onlineChats[indexPath.row] : historyChats[indexPath.row]
        performSegue(withIdentifier: conversationViewControllerID, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == conversationViewControllerID,
            let conversationVC = segue.destination as? ConversationViewController {
            conversationVC.chat = selectedChat
            conversationVC.managedObjectContext = managedObjectContext
        }
    }
    
    var selectedChat: Chat!
    var managedObjectContext: NSManagedObjectContext!
    var chats: [Chat]!
    var onlineChats: [Chat]!
    var historyChats: [Chat]!
    let conversationViewControllerID = "ConversationViewController"
    
}
