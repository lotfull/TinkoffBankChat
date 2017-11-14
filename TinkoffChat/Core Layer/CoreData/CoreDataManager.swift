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
    
    static func appendChat(with userID: String, userName: String?) {
        guard let saveContext = self.coreDataStack?.saveContext,
            let user = User.findOrInsertUser(withID: userID, in: saveContext),
            let chat = Chat.findOrInsertChat(with: userID, in: saveContext) else {
                print("findOrInsert(AppUser/Chat) incorrect", #function)
                return
        }
        user.isOnline = true
        chat.isOnline = true
        user.name = userName
        user.chat = chat
        
        coreDataStack?.performSave(context: saveContext, completion: { (success, error) in
            if !success {
                print("appendChat coreDataStack?.performSave() error \(error!)")
            }
        })
    }
    
    static func deleteChat(with userID: String) {
        guard let saveContext = self.coreDataStack?.saveContext,
            let user = User.findOrInsertUser(withID: userID, in: saveContext),
            let chat = Chat.findOrInsertChat(with: userID, in: saveContext) else {
                print("findOrInsert(AppUser/Chat) incorrect", #function)
                return
        }
        user.isOnline = false
        chat.isOnline = false
        
        coreDataStack?.performSave(context: saveContext, completion: { (success, error) in
            if !success {
                print("deleteChat coreDataStack?.performSave() error \(error!)")
            }
        })
    }
    
    static func saveMessage(with text: String, with partnerID: String, type: Bool) {
        let senderID = type == inbox ? partnerID : myID
        guard let saveContext = self.coreDataStack?.saveContext,
            let chat = Chat.findOrInsertChat(with: partnerID,
                                             in: saveContext),
            let sender = User.findOrInsertUser(withID: senderID,
                                               in: saveContext),
            let _ = Message.insertMessage(withText: text,
                                          fromSender: sender,
                                          toChat: chat,
                                          inContext: saveContext)
            else {
                print("saveMessage guard error")
                return
        }
        chat.hasUnreadMessages = type == inbox
        coreDataStack?.performSave(context: saveContext, completion: { (success, error) in
            if !success {
                print("saveMessage coreDataStack?.performSave() error \(error!)")
            }
        })
    }
    
    static func getAppUser() -> AppUser? {
        if let context = self.coreDataStack?.saveContext {
            return AppUser.findOrInsertAppUser(in: context)
        }
        return nil
    }
    
    static func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        guard let saveContext = coreDataStack?.saveContext,
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
        CoreDataManager.coreDataStack?.performSave(context: saveContext, completion: completion)
    }
    
    private static var myID: String {
        get {
            guard let saveContext = coreDataStack?.saveContext,
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










