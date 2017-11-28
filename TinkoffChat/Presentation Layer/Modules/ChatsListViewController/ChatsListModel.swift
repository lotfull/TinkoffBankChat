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
    func chatID(for indexPath: IndexPath) -> String
    func setup(_ tableView: UITableView)
}

class ChatsListModel: NSObject, IChatsListModel, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    private let chatDataService: IChatDataService
    private let communicationService: ICommunicationService
    
    private var tableView: UITableView!
    private var fetchedResultsController: NSFetchedResultsController<Chat>

    init(chatDataService: IChatDataService,
        communicationService: ICommunicationService) {
        self.chatDataService = chatDataService
        self.communicationService = communicationService
        let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
        let bySections = NSSortDescriptor(key: #keyPath(Chat.isOnline), ascending: false)
        let byDate = NSSortDescriptor(key: #keyPath(Chat.lastMessage.date), ascending: false)
        let byName = NSSortDescriptor(key: #keyPath(Chat.user.name), ascending: false)
        fetchRequest.sortDescriptors = [bySections, byDate, byName]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: chatDataService.mainContext, sectionNameKeyPath: #keyPath(Chat.isOnline), cacheName: nil)
        super.init()
    }
    
    func setup(_ tableView: UITableView) {
        self.tableView = tableView
        fetchedResultsController.delegate = self
//        self.tableView.register(nib, forCellReuseIdentifier: chatsTableViewCellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    /*
    private func sortForTableFormat(_ chats: [Chat]) -> [[Chat]] {
        var onlineChats1 = [Chat]()
        var onlineChats2 = [Chat]()
        var onlineChats3 = [Chat]()
        var offlineChats1 = [Chat]()
        var offlineChats2 = [Chat]()
        var offlineChats3 = [Chat]()
        for chat in chats {
            if chat.isOnline {
                if chat.lastMessage?.date != nil {
                    onlineChats1.append(chat)
                } else {
                    if chat.user.name != nil {
                        onlineChats2.append(chat)
                    } else {
                        onlineChats3.append(chat)
                    }
                }
            } else {
                if chat.lastMessage?.date != nil {
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
    */
    ///////////// ---- ////////////
    
    func chatID(for indexPath: IndexPath) -> String {
        guard let chatID = fetchedResultsController.object(at: indexPath).id else {
            preconditionFailure("No conversation found for passed index path")
        }
        return chatID
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else {
            preconditionFailure("no sections in fetchedResultsController")
        }
        guard sections[section].numberOfObjects > 0 else {
            return nil
        }
        let firstChatOfSection = fetchedResultsController.object(at: IndexPath(row: 0, section: section))
        return firstChatOfSection.isOnline ? "Online" : "History"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            preconditionFailure("no sections in fetchedResultsController")
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
        
        let chat = fetchedResultsController.object(at: indexPath)
        chatCell.nameLabel.text = chat.user?.name
        chatCell.message = chat.lastMessage?.text
        chatCell.date = chat.lastMessage?.date
        chatCell.online = chat.isOnline
        chatCell.hasUnreadMessages = chat.hasUnreadMessages
        return chatCell
    }
    
    
    // NSFRCD
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(#function)
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(#function)
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print(#function)
        switch type {
        case .delete:
            deleteRowsInTableAtIndexPath(indexPath)
        case .insert:
            insertRowsInTableAtIndexPath(newIndexPath)
        case .move:
            deleteRowsInTableAtIndexPath(indexPath)
            insertRowsInTableAtIndexPath(newIndexPath)
        default:
            break
        }
    }
    
    private func deleteRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        print(#function)
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
    
    private func insertRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        print(#function)
        if let indexPath = indexPath {
            tableView.insertRows(at: [indexPath], with: .none)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        print(#function)
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
}
