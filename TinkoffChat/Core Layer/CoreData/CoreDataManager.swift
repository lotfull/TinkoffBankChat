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
    func sentMessage(with text: String, toPartnerWithID partnerID: String)
    func readChat(withID chatID: String)
    func getUserNameForChat(withID chatID: String) -> String
    func isOnlineChat(withID chatID: String) -> Bool
    func turnChatsOffline()
    var mainContext: NSManagedObjectContext { get }
    func handleFoundUserWith(id: String, userName: String?)
    func handleLostUserWith(id: String)
    func handleSentMessageWith(text: String, toChatWithID conversationID: String)
    func handleReceivedMessageWith(text: String, fromUserID: String)
    func handleDidFindUser(userID: String, userName: String?)
    func handleDidLoseUser(userID: String)
    func handleFailedToStartBrowsingForUsers(error: Error)
    func handleFailedToStartAdvertising(error: Error)
    func handleDidReceiveMessage(text: String, fromUser: String, toUser: String)
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
    
    
    func handleFoundUserWith(id: String, userName: String?) {
        print("Handling found user!")
        let saveContext = self.coreDataStack.saveContext
        saveContext.perform {
            let chat = Chat.findOrInsertChat(withID: id, in: saveContext)
            chat.isOnline = true
            let user = User.findOrInsertUser(withID: id, in: saveContext)
            user.name = userName
            user.isOnline = true
            chat.isOnline = true
            user.chat = chat
            chat.user = user
            self.coreDataStack.performSave(in: saveContext, completion: nil)
        }
    }
    
    func handleLostUserWith(id: String) {
        print("Handling lost user!")
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let user = User.findOrInsertUser(withID: id, in: saveContext)
            user.isOnline = false
            let chat = Chat.findOrInsertChat(withID: id, in: saveContext)
            chat.isOnline = false
            self.coreDataStack.performSave(in: saveContext, completion: nil)
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
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////
    
    
    
    
    
    
    func handleDidFindUser(userID: String, userName: String?) {
        print(#function)
        saveContext.perform {
            let chat = Chat.findOrInsertChat(withID: userID, in: self.saveContext)
            let user = User.findOrInsertUser(withID: userID, in: self.saveContext)
            user.isOnline = true
            chat.isOnline = true
            user.name = userName
            user.chat = chat
            print(#function, chat)
            print(#function, user)
            self.coreDataStack.performSave(in: self.saveContext, completion: nil)
        }
    }
    
    func handleDidLoseUser(userID: String) {
        print(#function)
        let chat = Chat.findOrInsertChat(withID: userID, in: saveContext)
        let user = chat.user!
        user.isOnline = false
        chat.isOnline = false
        coreDataStack.performSave(context: saveContext, completion: { (success, error) in
            if !success {
                print("deleteChat coreDataStack?.performSave() error \(error!)")
            }
        })
    }
    
    func handleFailedToStartBrowsingForUsers(error: Error) {
        print(#function)
    }
    
    func handleFailedToStartAdvertising(error: Error) {
        print(#function)
    }
    
    func handleDidReceiveMessage(text: String, fromUser: String, toUser: String) {
        print(#function)
        saveMessage(withText: text, partnerID: fromUser, type: inbox)
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
    
    func sentMessage(with text: String, toPartnerWithID partnerID: String) {
        print(#function)
        saveMessage(withText: text, partnerID: partnerID, type: outbox)
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
    
    func saveMessage(withText text: String, partnerID: String, type: Bool) {
        print(#function)
        let chat = Chat.findOrInsertChat(withID: partnerID, in: self.saveContext)
        guard let _ = Message.insertMessage(withText: text,
                                          type: type,
                                          toChat: chat,
                                          inContext: self.saveContext)
            else {
                print("saveMessage guard error")
                return
        }
        chat.hasUnreadMessages = type == inbox
        coreDataStack.performSave(in: self.saveContext, completion: nil)
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










