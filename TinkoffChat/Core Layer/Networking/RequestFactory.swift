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
        static func editorChoiceImagesList() -> RequestConfig<[PixabayImageListAPIModel]> {
            return RequestConfig<[PixabayImageListAPIModel]>(request: PixabayEditorChoiceImagesRequest(), parser: PixabayImageListParser())
        }
        
        static func carImagesList() -> RequestConfig<[PixabayImageListAPIModel]> {
            return RequestConfig<[PixabayImageListAPIModel]>(request: PixabayCarImagesRequest(), parser: PixabayImageListParser())
        }
    }
    struct CommonRequest {
        static func loadImage(from url: URL) -> RequestConfig<PixabayImageAPIModel> {
            return RequestConfig<PixabayImageAPIModel>(request: LoadImageRequest(url), parser: PixabayLoadImageParser())
        }
    }
}

