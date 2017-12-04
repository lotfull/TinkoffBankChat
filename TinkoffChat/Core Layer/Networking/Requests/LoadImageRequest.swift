//
//  LoadImageRequest.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class LoadImageRequest: IRequest {
    private let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
}

