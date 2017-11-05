//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 16.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

//class GCDDataManager: ProfileManager {
//
//    private let serialQueue = DispatchQueue(label: "com.lotfull.gcdDataManagerQueue")
//    private let fileStorage = FileStorage()
//    let queue = DispatchQueue(label: "editProfileWithGCD.queue")
//
//    func loadProfile(completion: @escaping (Profile?, Error?) -> Void) {
//        serialQueue.async {
//            if let profile = self.fileStorage.loadProfile() {
//                DispatchQueue.main.async {
//                    completion(profile, nil)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    completion(nil, Errors.profileNotLoaded)
//                }
//            }
//        }
//    }
//
//    enum Errors: Error {
//        case profileNotLoaded
//    }
//
//    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
//        serialQueue.async {
//            if self.fileStorage.save(profile) {
//                DispatchQueue.main.async {
//                    completion(true, nil)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    completion(false, nil)
//                }
//            }
//        }
//    }
//
//    func saveObjects(_ objects: [Any?], toFile: String) -> Bool {
//        return NSKeyedArchiver.archiveRootObject(objects, toFile: toFile)
//    }
//
//}

