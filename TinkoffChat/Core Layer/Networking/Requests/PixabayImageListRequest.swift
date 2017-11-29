//
//  PixabayImageListRequest.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class PixabayImageListRequest: PixabayAPIRequest {
    var queryParameters: [String: String] {
        return ["key": apiKey,
                "imageType": "photo",
                "editors_choice": "true",
                "per_page": "100",
        ]
    }
}
