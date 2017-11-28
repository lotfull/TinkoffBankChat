//
//  ChatsListAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ChatsListAssembly {
    
    private func chatsListModel() -> IChatsListModel {
        return ChatsListModel(chatDataService: RootAssembly.chatDataService, communicationService: RootAssembly.communicationService)
    }
    
    func chatsListViewController() -> ChatsListViewController {
        let model = chatsListModel()
        let chatsListVC = ChatsListViewController.initWith(model: model)
        return chatsListVC
    }
    
}
