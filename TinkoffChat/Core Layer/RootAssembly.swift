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
    
    static let connectionManager: ConnectionManagerProtocol = ConnectionManager()
}
