//
//  ProfileService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol DataManager {
    func saveProfileData(profile: Profile, completionHandler: @escaping (CoreDataError?) -> () )
    func loadProfileData(completionHandler: @escaping (Profile, CoreDataError?) ->() )
}

enum CoreDataError: Error {
    case saveError
    case loadError
}

class ProfileService: DataManager {
    
    func saveProfileData(profile: Profile, completionHandler: @escaping (CoreDataError?) -> () ) {
        CoreDataManager.saveUserProfile(profile, success: completionHandler(.loadError))//saveUserData(profileData, success: handler(.loadError))
    }
    
    func loadProfileData(completionHandler: @escaping (Profile, CoreDataError?) -> ()) {
        if let myProfile = CoreDataManager.getAppUser() {
            DispatchQueue.main.async {
                completionHandler(myProfile, .loadError)
            }
        } else {
            print("Core data error")
        }
    }
}
