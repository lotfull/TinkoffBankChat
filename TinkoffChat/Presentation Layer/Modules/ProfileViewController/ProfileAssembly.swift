//
//  ProfileAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ProfileAssembly {
    func profileViewController() -> ProfileViewController {
        let model = profileModel()
        let profileVC = ProfileViewController.initWith(model: model)
        model.delegate = profileVC
        return profileVC
    }
    
    func profileModel() -> IProfileModel {
        return ProfileModel(profileService: profileService())
    }
    
    func profileService() -> ProfileService {
        return ProfileService(coreDataManager: RootAssembly.coreDataManager)
    }
}
