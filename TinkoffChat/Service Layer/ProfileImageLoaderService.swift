//
//  ProfileImageLoaderService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IProfileImageLoaderService: class {
    func loadImages(completion: @escaping ([PixabayImageListAPIModel]?, String?) -> Void)
    func loadImage(from url: URL, completion: @escaping (PixabayImageAPIModel?, String?) -> Void)
}

class ProfileImageLoaderService: IProfileImageLoaderService {
    private let requestSender: IRequestSender
    
    init(_ requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadImages(completion: @escaping ([PixabayImageListAPIModel]?, String?) -> Void) {
        let imageListConfig: RequestConfig<[PixabayImageListAPIModel]> = RequestsFactory.PixabayAPIRequests.editorChoiceImagesList()
        requestSender.send(config: imageListConfig) { (result: Result<[PixabayImageListAPIModel]>) in
            switch result {
            case .success(let images):
                completion(images, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (PixabayImageAPIModel?, String?) -> Void) {
        let loadImageConfig: RequestConfig<PixabayImageAPIModel> = RequestsFactory.CommonRequest.loadImage(from: url)
        requestSender.send(config: loadImageConfig) { (result: Result<PixabayImageAPIModel>) in
            switch result {
            case .success(let model):
                completion(model, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
}
