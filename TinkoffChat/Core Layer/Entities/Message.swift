//
//  Message.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import CoreData

//class Message {
//    let type: MessageType
//    let text: String
//    let date: Date
//    var isRead = false
//
//    init(text: String, date: Date, type: MessageType) {
//        self.date = date
//        self.text = text
//        self.type = type
//    }
//
//    func makeReaded() {
//        isRead = true
//    }
//}
//
//enum MessageType {
//    case inbox
//    case outbox
//}
extension Message {
    static func insertMessage(withText text: String, fromSender sender: User, toChat chat: Chat, inContext context: NSManagedObjectContext) -> Message? {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else {
            print("Failed insertNewObject(forEntityName: Message")
            return nil
        }
        let messageID = sender.id + "\(Date.timeIntervalSinceReferenceDate)" + "\(arc4random_uniform(1000000))"
        message.id = messageID
        message.text = text
        message.sender = sender
        message.date = Date()
        message.chat = chat
        message.lastInChat = chat
        return message
    }
    
    static func fetchRequestMessageByChatID(ID: String, model: NSManagedObjectModel) -> NSFetchRequest<Message>? {
        let requestName = "MessageByChatID"
        guard let fetchRequest = model.fetchRequestTemplate(forName: requestName) as? NSFetchRequest<Message> else {
            assert(false, "No fetch request template with name \(requestName)")
            return nil
        }
        return fetchRequest
    }
}

let inbox = true
let outbox = false

