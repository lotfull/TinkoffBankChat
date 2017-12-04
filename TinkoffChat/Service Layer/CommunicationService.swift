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
    func sendMessage(text: String, to userID: String, completion: ((Bool, Error?) -> Void)?)
}

class CommunicationService: NSObject, ICommunicationService {
    
    let coreDataManager: ICoreDataManager
    var communicator: ICommunicator
    
    override init() {
        self.coreDataManager = RootAssembly.coreDataManager
        self.communicator = RootAssembly.multipeerCommunicator
        super.init()
        self.communicator.delegate = self
        self.coreDataManager.turnChatsOffline()
    }
}

extension CommunicationService: ICommunicatorDelegate {
    
    func didFindUser(userID: String, userName: String?) {
        coreDataManager.handleDidFindUser(userID: userID, userName: userName)
    }
    
    func didLoseUser(userID: String) {
        coreDataManager.handleDidLostUser(userID: userID)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        coreDataManager.handleDidReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func sendMessage(text: String, to userID: String, completion: ((Bool, Error?) -> Void)?) {
        print(#function)
        communicator.sendMessage(string: text, to: userID) { success, error in
            if !success { completion!(success, error) }
            self.coreDataManager.sentMessage(with: text, toUserWithID: userID)
            completion!(success, error)
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        coreDataManager.handleFailedToStartBrowsingForUsers(error: error)
    }
    
    func failedToStartAdvertising(error: Error) {
        coreDataManager.handleFailedToStartAdvertising(error: error)
    }
}
