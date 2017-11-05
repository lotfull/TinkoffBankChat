//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IProfileModel: class {
    weak var delegate: ProfileDelegate? { get set }
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void)
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
}

protocol ProfileDelegate: class {
    func updateUI(firstTime: Bool)
}

class ProfileModel: IProfileModel {
    
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void) {
        profileService.loadProfile(completion: completion)
    }
    
    weak var delegate: ProfileDelegate?
    
    let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        profileService.saveProfile(profile, completion: completion)
    }
    
    
    
    
}
