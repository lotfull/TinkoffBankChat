//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 16.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class GCDDataManager: ProfileDelegate {
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void) {
        
    }
    
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) -> Bool {
        
    }
    
    private let serialQueue = DispatchQueue(label: "com.lotfull.gcdDataManagerQueue")
    private let dataStorage = FileStorage()
    
    let queue = DispatchQueue(label: "editProfileWithGCD.queue")
    func saveObjects(_ objects: [Any?], toFile: String) -> Bool {
        return NSKeyedArchiver.archiveRootObject(objects, toFile: toFile)
    }
    
}
