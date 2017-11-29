//
//  Message.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    static func insertMessage(withText text: String, type: Bool, toChat chat: Chat, inContext context: NSManagedObjectContext) -> Message? {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else {
            print("Failed insertNewObject(forEntityName: Message")
            return nil
        }
        let messageID = chat.id! + "\(Date.timeIntervalSinceReferenceDate)" + "\(arc4random_uniform(1000000))"
        message.id = messageID
        message.text = text
        message.type = type
        message.date = Date()
        message.chat = chat
        message.lastInChat = chat
        return message
    }
    
    static func fetchRequestMessageByChatID(ID: String, model: NSManagedObjectModel) -> NSFetchRequest<Message> {
        let requestName = "MessagesByChatID"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: requestName, substitutionVariables: ["id" : ID]) as? NSFetchRequest<Message> else {
            assert(false, "No fetch request template with name \(requestName)")
        }
        return fetchRequest
    }
}

let inbox = true
let outbox = false

