//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 05.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

protocol ICoreDataManager {
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void)
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    func readChat(withID chatID: String)
    func getUserNameForChat(withID chatID: String) -> String
    func isOnlineChat(withID chatID: String) -> Bool
    func turnChatsOffline()
    var mainContext: NSManagedObjectContext { get }
    func handleDidFindUser(userID: String, userName: String?)
    func handleDidLostUser(userID: String)
    func handleDidReceiveMessage(text: String, fromUser ID: String, toUser: String)
    func sentMessage(with text: String, toUserWithID ID: String)
    func handleFailedToStartBrowsingForUsers(error: Error)
    func handleFailedToStartAdvertising(error: Error)
}

class CoreDataManager: ICoreDataManager {
    
    private var _coreDataStack: CoreDataStack?
    private var coreDataStack: CoreDataStack {
        get {
            if _coreDataStack == nil {
                _coreDataStack = CoreDataStack.init()
            }
            return _coreDataStack!
        }
    }
    
    // MARK: Message
    
    func handleSentMessageWith(text: String, toChatWithID chatID: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let message = self.createMessageWith(text: text, in: saveContext)
            message.type = outbox
            let chat = Chat.findOrInsertChat(withID: chatID, in: saveContext)
            message.chat = chat
            chat.addToMessages(message)
            chat.lastMessage = message
            self.coreDataStack.performSave(in: saveContext, completion: nil)
        }
    }
    
    func handleReceivedMessageWith(text: String, fromUserID: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let chat = Chat.findOrInsertChat(withID: fromUserID, in: saveContext)
            let message = self.createMessageWith(text: text, in: saveContext)
            message.type = inbox
            message.chat = chat
            chat.lastMessage = message
            chat.hasUnreadMessages = true
            chat.addToMessages(message)
            print("*** message", message)
            self.coreDataStack.performSave(in: saveContext, completion: nil)
        }
    }
    
    func createMessageWith(text: String, in context: NSManagedObjectContext) -> Message {
        let message = Message(context: context)
        message.id = "\(Date.timeIntervalSinceReferenceDate)" + "\(arc4random_uniform(1000000))"
        message.date = Date()
        message.text = text
        return message
    }
    
    func handleDidFindUser(userID: String, userName: String?) {
        saveContext.perform {
            let chat = Chat.findOrInsertChat(withID: userID, in: self.saveContext)
            guard let user = chat.user else { assertionFailure("no chat.user"); return }
//            let user = User.findOrInsertUser(withID: userID, in: self.saveContext)
            user.isOnline = true
            chat.isOnline = true
            user.name = userName
            user.chat = chat
            self.coreDataStack.performSave(in: self.saveContext, completion: nil)
        }
    }
    
    func handleDidLostUser(userID: String) {
        saveContext.perform {
            let chat = Chat.findOrInsertChat(withID: userID, in: self.saveContext)
            let user = chat.user!
            user.isOnline = false
            chat.isOnline = false
            self.coreDataStack.performSave(context: self.saveContext, completion: { _, _ in })
        }
    }

    func handleDidReceiveMessage(text: String, fromUser ID: String, toUser: String) {
        saveMessage(withText: text, userID: ID, type: inbox)
    }
    
    func sentMessage(with text: String, toUserWithID ID: String) {
        saveMessage(withText: text, userID: ID, type: outbox)
    }

    func saveMessage(withText text: String, userID: String, type: Bool) {
        saveContext.perform {
            let chat = Chat.findOrInsertChat(withID: userID, in: self.saveContext)
            Message.insertMessage(withText: text,
                                  type: type,
                                  toChat: chat,
                                  inContext: self.saveContext)
            self.coreDataStack.performSave(in: self.saveContext, completion: nil)
        }
    }
    
    func handleFailedToStartBrowsingForUsers(error: Error) {
        print(#function)
    }
    
    func handleFailedToStartAdvertising(error: Error) {
        print(#function)
    }
    
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void) {
        if let appUser = getAppUser(),
            let user = appUser.currentUser {
            let image = user.image != nil ? UIImage(data: user.image!) : #imageLiteral(resourceName: "placeholder-user")
            let myProfile = Profile(name: user.name,
                                    info: user.info,
                                    image: image)
            completion(myProfile, nil)
        } else {
            print("loadProfile Core data error")
            completion(nil, CoreDataError.loadError)
        }
    }
    
    func turnChatsOffline() {
        print(#function)
        self.masterContext.performAndWait {
            let asyncBatchUpdateRequest = NSBatchUpdateRequest(entity: Chat.entity())
            asyncBatchUpdateRequest.propertiesToUpdate = ["isOnline": NSNumber(value: false)]
            asyncBatchUpdateRequest.resultType = .updatedObjectIDsResultType
            do {
                guard let objectIDsResult = try masterContext.execute(asyncBatchUpdateRequest) as? NSBatchUpdateResult else {
                    assertionFailure("Failed batch updating for chats")
                    return
                }
                guard let objectIDs = objectIDsResult.result as? [NSManagedObjectID] else {
                    assertionFailure("Wrong type of NSBatchResult was expected")
                    return
                }
                self.mainContext.performAndWait {
                    for objectID in objectIDs {
                        let object = mainContext.object(with: objectID)
                        mainContext.refresh(object, mergeChanges: true)
                    }
                    coreDataStack.performSave(context: masterContext) {_,_ in}
                }
            } catch {
                print("Failed batch updating for chats")
            }
        }
    }
    
    var mainContext: NSManagedObjectContext {
        return self.coreDataStack.mainContext
    }
    var saveContext: NSManagedObjectContext {
        return self.coreDataStack.saveContext
    }
    var masterContext: NSManagedObjectContext {
        return self.coreDataStack.masterContext
    }
    
    func readChat(withID chatID: String) {
        let chat = Chat.findOrInsertChat(withID: chatID, in: self.saveContext)
        chat.hasUnreadMessages = false
        self.coreDataStack.performSave(context: self.saveContext) {_,_ in}
    }
    
    func getUserNameForChat(withID chatID: String) -> String {
        let user = User.findOrInsertUser(withID: chatID, in: self.saveContext)
        return user.name ?? "Unnamed"
    }
    
    func isOnlineChat(withID chatID: String) -> Bool {
        let chat = Chat.findOrInsertChat(withID: chatID, in: self.saveContext)
        return chat.isOnline
    }
    
    func getAppUser() -> AppUser? {
        return AppUser.findOrInsertAppUser(in: self.saveContext)
    }
    
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        guard let appUser = AppUser.findOrInsertAppUser(in: self.saveContext),
            let user = appUser.currentUser else {
            print("findOrInsertAppUser incorrect", #function)
            completion(false, CoreDataError.saveError)
            return
        }
        user.name = profile.name
        user.info = profile.info
        if profile.image != nil {
            user.image = UIImageJPEGRepresentation((profile.image)!, 1.0) as Data?
        }
        coreDataStack.performSave(context: self.saveContext, completion: completion)
    }
}










