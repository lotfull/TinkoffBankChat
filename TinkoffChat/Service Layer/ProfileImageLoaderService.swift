//
//  ProfileImageLoaderService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IProfileImageLoaderService: class {
    func loadImages(completionHandler: @escaping ([PixabayImageListAPIModel]?, String?) -> Void)
    func loadImage(from url: URL, completionHandler: @escaping (PixabayImageAPIModel?, String?) -> Void)
}

class ProfileImageLoaderService: IProfileImageLoaderService {
    private let requestSender: IRequestSender
    
    init(_ requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadImages(completionHandler: @escaping ([PixabayImageListAPIModel]?, String?) -> Void) {
        let imageListConfig: RequestConfig<[PixabayImageListAPIModel]> = RequestsFactory.PixabayAPIRequests.editorChoiceImagesList()
        requestSender.send(config: imageListConfig) { (result: Result<[PixabayImageListAPIModel]>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func loadImage(from url: URL, completionHandler: @escaping (PixabayImageAPIModel?, String?) -> Void) {
        let loadImageConfig: RequestConfig<PixabayImageAPIModel> = RequestsFactory.CommonRequest.loadImage(from: url)
        requestSender.send(config: loadImageConfig) { (result: Result<PixabayImageAPIModel>) in
            switch result {
            case .success(let model):
                completionHandler(model, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
}
