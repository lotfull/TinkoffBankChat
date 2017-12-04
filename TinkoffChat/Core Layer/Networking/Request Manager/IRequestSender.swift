//
//  IRequestSender.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IRequestSender: class {
    func send<T>(config: RequestConfig<T>, completion: @escaping (Result<T>) -> Void)
}
