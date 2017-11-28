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
    func handleDidFindUser(userID: String, userName: String?)
    func handleDidLoseUser(userID: String)
    func handleFailedToStartBrowsingForUsers(error: Error)
    func handleFailedToStartAdvertising(error: Error)
    func handleDidReceiveMessage(text: String, fromUser: String, toUser: String)
}


class CoreDataManager: ICoreDataManager {
    
    private static var _coreDataStack: CoreDataStack?
    public static var coreDataStack: CoreDataStack? {
        get {
            if _coreDataStack == nil {
                _coreDataStack = CoreDataStack.init()
            }
            return _coreDataStack
        }
    }
    
    func handleDidFindUser(userID: String, userName: String?) {
        print(#function)
        guard let coreDataStack = CoreDataManager.coreDataStack,
            let saveContext = coreDataStack.saveContext else {
                print("findOrInsert(AppUser/Chat) incorrect", #function)
                return
        }
        saveContext.perform {
            guard let chat = Chat.findOrInsertChat(withChatID: userID, in: saveContext),
                let user = User.findOrInsertUser(withID: userID, in: saveContext) else { print("(chat/user) not (find/insert)ed"); return }
            user.isOnline = true
            chat.isOnline = true
            user.name = userName
            user.chat = chat
            print(#function, chat)
            print(#function, user)
            coreDataStack.performSave(in: saveContext, completionHandler: nil)
        }
    }
    
    func handleDidLoseUser(userID: String) {
        print(#function)
        guard let coreDataStack = CoreDataManager.coreDataStack,
            let saveContext = coreDataStack.saveContext,
            let chat = Chat.findOrInsertChat(withChatID: userID, in: saveContext),
            let user = chat.user else {
                print("findOrInsert(AppUser/Chat) incorrect", #function)
                return
        }
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
            let myProfile = Profile(name: user.name ?? "Unnamed User",
                                    info: user.info ?? "No info",
                                    image: image)
            completion(myProfile, nil)
        } else {
            print("loadProfile Core data error")
            completion(nil, CoreDataError.loadError)
        }
    }
    
    func turnChatsOffline() {
        print(#function)
        guard let coreDataStack = CoreDataManager.coreDataStack,
            let masterContext = coreDataStack.masterContext else { return }
        masterContext.performAndWait {
            let asyncBatchUpdateRequest = NSBatchUpdateRequest(entity: Chat.entity())
            asyncBatchUpdateRequest.propertiesToUpdate = ["isOnline": NSNumber(value: false)]
            asyncBatchUpdateRequest.resultType = .updatedObjectIDsResultType
            do {
                guard let objectIDsResult = try masterContext.execute(asyncBatchUpdateRequest) as? NSBatchUpdateResult else {
                    assertionFailure("Failed batch updating for conversations")
                    return
                }
                guard let objectIDs = objectIDsResult.result as? [NSManagedObjectID] else {
                    assertionFailure("Wrong type of NSBatchResult was expected")
                    return
                }
                guard let mainContext = coreDataStack.mainContext else { return }
                mainContext.performAndWait {
                    for objectID in objectIDs {
                        let object = mainContext.object(with: objectID)
                        mainContext.refresh(object, mergeChanges: true)
                    }
                    coreDataStack.performSave(context: masterContext) {_,_ in}
                }
            } catch {
                print("Failed batch updating for conversations")
            }
        }
    }
    
    var mainContext: NSManagedObjectContext {
        guard let mainContext = CoreDataManager.coreDataStack?.mainContext else { fatalError("mainContext nil") }
        return mainContext
    }
    
    func sentMessage(with text: String, toPartnerWithID partnerID: String) {
        print(#function)
        saveMessage(withText: text, partnerID: partnerID, type: outbox)
    }
    
    func readChat(withID chatID: String) {
        guard let coreDataStack = CoreDataManager.coreDataStack,
            let saveContext = coreDataStack.saveContext,
            let chat = Chat.findOrInsertChat(withChatID: chatID, in: saveContext) else {
                print("readChat error")
                return
        }
        chat.hasUnreadMessages = false
        coreDataStack.performSave(context: saveContext) {_,_ in}
    }
    
    func getUserNameForChat(withID chatID: String) -> String {
        guard let coreDataStack = CoreDataManager.coreDataStack,
            let saveContext = coreDataStack.saveContext,
            let user = User.findOrInsertUser(withID: chatID, in: saveContext) else { print("getUserNameForChat error"); return "Unnamed" }
        return user.name ?? "Unnamed"
    }
    
    func isOnlineChat(withID chatID: String) -> Bool {
        guard let coreDataStack = CoreDataManager.coreDataStack,
            let saveContext = coreDataStack.saveContext,
            let chat = Chat.findOrInsertChat(withChatID: chatID, in: saveContext) else { print("isOnlineChat error"); return false }
        return chat.isOnline
    }
    
    func saveMessage(withText text: String, partnerID: String, type: Bool) {
        print(#function)
        guard let coreDataStack = CoreDataManager.coreDataStack,
            let saveContext = coreDataStack.saveContext,
            let chat = Chat.findOrInsertChat(withChatID: partnerID, in: saveContext),
            let _ = Message.insertMessage(withText: text,
                                          type: type,
                                          toChat: chat,
                                          inContext: saveContext)
            else {
                print("saveMessage guard error")
                return
        }
        chat.hasUnreadMessages = type == inbox
        coreDataStack.performSave(in: saveContext, completionHandler: nil)
    }
    
    func getAppUser() -> AppUser? {
        if let context = CoreDataManager.coreDataStack?.saveContext {
            return AppUser.findOrInsertAppUser(in: context)
        }
        return nil
    }
    
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        guard let coreDataStack = CoreDataManager.coreDataStack,
            let saveContext = coreDataStack.saveContext,
            let appUser = AppUser.findOrInsertAppUser(in: saveContext),
            let user = appUser.currentUser else {
            print("findOrInsertAppUser incorrect", #function)
            completion(false, CoreDataError.saveError)
            return
        }
        user.name = profile.name
        user.info = profile.info
        if profile.image != nil {
            user.image = UIImagePNGRepresentation((profile.image)!) as Data?
        }
        coreDataStack.performSave(context: saveContext, completion: completion)
    }
    
    private var myID: String {
        get {
            guard let saveContext = CoreDataManager.coreDataStack?.saveContext,
                let appUser = AppUser.findOrInsertAppUser(in: saveContext),
                let currentUserID = appUser.currentUser?.id else {
                    print("App User Not Found in myID")
                    return UUID().uuidString
            }
            return currentUserID
        }
    }

//    guard let appUser = AppUser.findOrInsertAppUser(in: stack.saveContext),
//            let currentUserID = appUser.currentUser?.id else {
//                assertionFailure()
//                return UUID().uuidString
//        }
//        return currentUserID
}










