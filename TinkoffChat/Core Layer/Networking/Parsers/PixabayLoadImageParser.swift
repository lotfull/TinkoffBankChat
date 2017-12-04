//
//  PixabayLoadImageParser.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

struct PixabayImageAPIModel {
    let image: UIImage
}

class PixabayLoadImageParser: AnyParser<PixabayImageAPIModel> {
    override func parse(data: Data) -> PixabayImageAPIModel? {
        if let image = UIImage(data: data) {
            return PixabayImageAPIModel(image: image)
        } else {
            return nil
        }
    }
}
