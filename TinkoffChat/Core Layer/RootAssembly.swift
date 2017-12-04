//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class RootAssembly {
    
    var ChatsListModule: ChatsListAssembly = ChatsListAssembly()
    static let coreDataManager: CoreDataManager = CoreDataManager()
    static let multipeerCommunicator: ICommunicator = MultipeerCommunicator()
    static let communicationService: ICommunicationService = CommunicationService()
    static let chatDataService: IChatDataService = ChatDataService()
    static let profileImagePickerAssembly = ProfileImagePickerAssembly()

}
