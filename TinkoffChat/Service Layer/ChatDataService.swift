//
//  ChatDataService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 14.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import CoreData

protocol IChatDataService: class {
    func getUserNameForChat(withID chatID: String) -> String
    func isOnlineChat(withID chatID: String) -> Bool
    func makeReadChat(withID chatID: String)
    var mainContext: NSManagedObjectContext { get }
}

class ChatDataService: IChatDataService {
    
    let coreDataManager = RootAssembly.coreDataManager
    
    var mainContext: NSManagedObjectContext {
        return coreDataManager.mainContext
    }
    
    func getUserNameForChat(withID chatID: String) -> String {
        return coreDataManager.getUserNameForChat(withID: chatID)
    }
    func isOnlineChat(withID chatID: String) -> Bool {
        return coreDataManager.isOnlineChat(withID: chatID)
    }
    func makeReadChat(withID chatID: String) {
        coreDataManager.readChat(withID: chatID)
    }
}
