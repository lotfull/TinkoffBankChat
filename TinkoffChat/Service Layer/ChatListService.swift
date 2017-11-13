//
//  ChatListService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 13.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

protocol IChatListService: class {
    
}

class ChatListService: NSObject, IChatListService {
    var frc: NSFetchedResultsController<Chat>?
    let stack: ICoreDataStack
    var tableView: UITableView? {
        didSet {
            do {
                try self.frc?.performFetch()
                self.tableView?.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    init(stack: ICoreDataStack) {
        self.stack = stack
        
        let mainContext = stack.mainContext
        var persistentStore = mainContext?.persistentStoreCoordinator
        if let parent = mainContext?.parent {
            persistentStore = parent.persistentStoreCoordinator
        }
        let fetchRequestManager
        
        
        super.init()
    }
}
