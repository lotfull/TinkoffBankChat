//
//  Chat.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import CoreData

//class Chat {
//    let id: String
//    var name: String?
//    var messages = [Message]()
//    var isOnline: Bool
//    var hasUnreadMessages: Bool {
//        return messages.last?.isRead ?? false
//    }
//    var lastMessageDate: Date? {
//        return messages.last?.date
//    }
//    
//    init(id: String, name: String?, isOnline: Bool) {
//        self.id = id
//        self.name = name ?? "Unnamed"
//        self.isOnline = isOnline
//    }
//}

extension Chat {
    static func findOrInsertChat(with ID: String, in context: NSManagedObjectContext) -> Chat? {
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        guard let fetchRequest = Chat.fetchRequestChat(with: ID, model: model) else {
            return nil
        }
        var chat: Chat?
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple chats found!")
            if let foundChat = results.first {
                chat = foundChat
            }
        } catch {
            print("Failed to fetch Chat: \(error)")
        }
        if chat == nil {
            chat = Chat.insertChat(with: ID, in: context)
        }
        return chat
    }
    
    static func fetchRequestChat(with ID: String, model: NSManagedObjectModel) -> NSFetchRequest<Chat>? {
        let requestName = "ChatByID"
        guard let fetchRequest = model.fetchRequestTemplate(forName: requestName) as? NSFetchRequest<Chat> else {
            assert(false, "No fetch request template with name \(requestName)")
            return nil
        }
        return fetchRequest
    }
    
    static func insertChat(with ID: String, in context: NSManagedObjectContext) -> Chat? {
        if let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as? Chat {
            chat.id = ID
            return chat
        }
        return nil
    }
}
