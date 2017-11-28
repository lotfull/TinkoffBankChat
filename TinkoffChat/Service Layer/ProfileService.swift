//
//  ProfileService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

enum CoreDataError: Error {
    case loadError
    case saveError
}
protocol IProfileService: class {
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void)
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
}

class ProfileService: IProfileService {
    
    let coreDataManager: CoreDataManager
    
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void) {
        coreDataManager.loadProfile(completion: completion)
    }
    
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        coreDataManager.saveProfile(profile, completion: completion)
    }
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
}


//if let appUser = CoreDataManager.getAppUser(),
//    let user = appUser.currentUser {
//    let image = user.image != nil ? UIImage(data: user.image!) : #imageLiteral(resourceName: "placeholder-user")
//    let myProfile = Profile(name: user.name ?? "Unnamed User",
//                            info: user.info ?? "No info",
//                            image: image)
//    completion(myProfile, nil)
//} else {
//    print("Core data error")
//    completion(nil, CoreDataError.loadError)
//}

