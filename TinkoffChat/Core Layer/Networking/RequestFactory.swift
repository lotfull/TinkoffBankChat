//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

struct RequestsFactory {
    struct PixabayAPIRequests {
        static func imageList() -> RequestConfig<[PixabayImageListAPIModel]> {
            return RequestConfig<[PixabayImageListAPIModel]>(request: PixabayImageListRequest(), parser: PixabayImageListParser())
        }
    }
    struct CommonRequest {
        static func loadImage(from url: URL) -> RequestConfig<PixabayImageAPIModel> {
            return RequestConfig<PixabayImageAPIModel>(request: LoadImageRequest(url), parser: PixabayLoadImageParser())
        }
    }
}

