//
//  AnyParser.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class AnyParser<T> {
    func parse(data: Data) -> T? {
        fatalError("This class should be subclassed")
    }
}

