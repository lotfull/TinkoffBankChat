//
//  ChatsListAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class ChatsListAssembly {
    func ChatsListViewController_() -> ChatsListViewController_ {
        let model = ChatsListModel()
        let chatsListVC = ChatsListViewController_(model: model)
        model.delegate = chatsListVC
        return chatsListVC
    }
}
