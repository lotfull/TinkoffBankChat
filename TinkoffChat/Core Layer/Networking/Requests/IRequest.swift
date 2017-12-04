//
//  IRequest.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IRequest: class {
    var urlRequest: URLRequest { get }
}
