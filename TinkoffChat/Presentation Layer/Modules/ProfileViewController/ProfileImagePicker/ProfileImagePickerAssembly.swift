//
//  ProfileImagePickerAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

class ProfileImagePickerAssembly {
    func assembly(_ profileImagePickerViewController: ProfileImagePickerViewController) {
        profileImagePickerViewController.model = getModel()
    }
    
    func getModel() -> IProfileImagePickerModel {
        return ProfileImagePickerModel(getImageLoaderService())
    }
    
    func getImageLoaderService() -> IProfileImageLoaderService {
        return ProfileImageLoaderService(getRequestSender())
    }
    
    func getRequestSender() -> IRequestSender {
        return RequestSender()
    }
}

