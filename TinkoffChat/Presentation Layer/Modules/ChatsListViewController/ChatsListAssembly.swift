//
//  ChatsListAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ChatsListAssembly {
    
    func chatsListViewController() -> ChatsListViewController {
        let model = chatsListModel()
        let chatsListVC = ChatsListViewController.initWith(model: model)
        model.delegate = chatsListVC
        return chatsListVC
    }
    
    private func chatsListModel() -> IChatsListModel {
        return ChatsListModel(peersService: peersService())
    }
    
    private func peersService() -> PeersService {
        return PeersService(connectionManager: connectionManager())
    }
    
    private func connectionManager() -> IConnectionManager {
        return RootAssembly.connectionManager
    }
    
}
