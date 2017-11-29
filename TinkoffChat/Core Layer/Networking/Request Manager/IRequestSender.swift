//
//  IRequestSender.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IRequestSender: class {
    func send<Model>(config: RequestConfig<Model>, completionHandler: @escaping (Result<Model>) -> Void)
}
