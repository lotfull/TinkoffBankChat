//
//  ProfileService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

protocol DataManager {
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void)
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
}

enum CoreDataError: Error {
    case loadError
    case saveError
}

class ProfileService: DataManager {
    
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void) {
        if let appUser = CoreDataManager.getAppUser() {
            let image = appUser.image != nil ? UIImage(data: appUser.image!) : #imageLiteral(resourceName: "placeholder-user")
            let myProfile = Profile(name: appUser.name ?? "Unnamed User",
                                    info: appUser.info ?? "No info",
                                    image: image)
//            DispatchQueue.main.async {
            completion(myProfile, nil)
//            }
        } else {
            print("Core data error")
            completion(nil, CoreDataError.loadError)
        }
    }
    
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        CoreDataManager.saveProfile(profile, completion: completion)
    }
    
//    func saveProfile(profile: Profile, completionHandler: @escaping (CoreDataError?) -> () ) {
//
//    }
//
//    func loadProfile(completionHandler: @escaping (Profile, CoreDataError?) -> ()) {
//        if let appUser = CoreDataManager.getAppUser() {
//            let myProfile = Profile(name: appUser.name, info: appUser.info, image: UIImage(data: appUser.image ?? Data()))
//            DispatchQueue.main.async {
//                completionHandler(myProfile, .loadError)
//            }
//        } else {
//            print("Core data error")
//        }
//    }
}
