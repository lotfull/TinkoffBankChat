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

