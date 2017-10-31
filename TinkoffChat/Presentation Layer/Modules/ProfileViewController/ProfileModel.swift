//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IProfileModel: class {
    // func A ()
}

class ProfileModel: IProfileModel {
//    weak var delegate:
    
    let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    // func A () { ... }
    
    
}
