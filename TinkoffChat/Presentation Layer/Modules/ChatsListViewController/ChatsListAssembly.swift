//
//  ChatsListAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ChatsListAssembly {
    func ChatsListViewControllerr() -> ChatsListViewController_ {
        let model = chatsListModel()
        let chatsListVC = initVC(with: model)
        model.delegate = chatsListVC
        return chatsListVC
    }
    
    private func chatsListModel() -> ChatsListModel {
        return ChatsListModel(multipeerService: multipeerService())
    }
    
    private func multipeerService() -> MultipeerService {
        return MultipeerService(connector: multipeerConnector)
    }
    
    private let multipeerConnector = MultipeerConnector()
    
    private func initVC(with model: ChatsListModel) -> ChatsListViewController_ {
        let chatsListVC_ = UIStoryboard(name: "ChatsList", bundle: nil).instantiateViewController(withIdentifier: "ChatsListViewController_") as! ChatsListViewController_
        chatsListVC_.model = model
        return chatsListVC_
    }
    
}
