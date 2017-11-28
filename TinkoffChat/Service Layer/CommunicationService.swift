//
//  CommunicationService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 13.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

protocol ICommunicationService: class {
    func sendMessage(text: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?)
}

class CommunicationService: NSObject, ICommunicationService, ICommunicatorDelegate {
    func didFindUser(userID: String, userName: String?) {
        coreDataManager.handleDidFindUser(userID: userID, userName: userName)
    }
    
    func didLoseUser(userID: String) {
        coreDataManager.handleDidLoseUser(userID: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        coreDataManager.handleFailedToStartBrowsingForUsers(error: error)
    }
    
    func failedToStartAdvertising(error: Error) {
        coreDataManager.handleFailedToStartAdvertising(error: error)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        coreDataManager.handleDidReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    let coreDataManager: ICoreDataManager// = RootAssembly.coreDataManager
    var communicator: ICommunicator/// = RootAssembly.multipeerCommunicator
    
    override init() {
        self.coreDataManager = RootAssembly.coreDataManager
        self.communicator = RootAssembly.multipeerCommunicator
        super.init()
        self.communicator.delegate = self
    }
    
    func sendMessage(text: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        print(#function)
        communicator.sendMessage(string: text, to: userID) { success, error in
            guard success == true else {
                print("CommunicationService sendMessage fall")
                return
            }
            self.coreDataManager.sentMessage(with: text, toPartnerWithID: userID)
            completionHandler!(success, error)
        }
    }
    
//
//    var frc: NSFetchedResultsController<Chat>?
//    let stack: ICoreDataStack
//    var tableView: UITableView? {
//        didSet {
//            do {
//                try self.frc?.performFetch()
//                self.tableView?.reloadData()
//            } catch {
//                print(error)
//            }
//        }
//    }
//
//    init(stack: ICoreDataStack) {
//        self.stack = stack
//
//        let mainContext = stack.mainContext
//        var persistentStore = mainContext?.persistentStoreCoordinator
//        if let parent = mainContext?.parent {
//            persistentStore = parent.persistentStoreCoordinator
//        }
//        let fetchRequestManager
//
//
//        super.init()
//    }
}
