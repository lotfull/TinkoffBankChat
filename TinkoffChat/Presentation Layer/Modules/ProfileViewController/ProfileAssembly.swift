//
//  ProfileAssembly.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class ProfileAssembly {
    func profileViewController() -> ProfileViewController {
        let model = profileModel()
        
    }
    
    func profileModel() -> IProfileModel {
        return ProfileModel(profileService: profileService())
    }
    
    func profileService() -> ProfileService {
        return ProfileService()
    }
}
