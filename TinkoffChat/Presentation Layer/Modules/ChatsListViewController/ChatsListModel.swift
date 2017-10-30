//
//  chatsListModel_.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IChatsListModelDelegate: class {
    
}

protocol IChatsListModel: class {
    
}

class ChatsListModel: IChatsListModel {
    weak var delegate: IChatsListModelDelegate?
    
    
}
