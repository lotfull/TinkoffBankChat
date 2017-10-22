//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 16.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import UIKit

class SaveOperation: Operation {
    enum Errors: Error {
        case profileNotSavedInOperation
    }
    
    private let profile: Profile
    private let completion: (Bool, Error?) -> Void
    private let fileStorage: FileStorage
    
    init(profile: Profile, fileStorage: FileStorage, completion: @escaping (Bool, Error?) -> Void) {
        self.profile = profile
        self.fileStorage = fileStorage
        self.completion = completion
    }
    
    override func main() {
        guard !isCancelled else { return }
        if fileStorage.save(profile) {
            DispatchQueue.main.async {
                self.completion(true, nil)
            }
        } else {
            self.completion(false, Errors.profileNotSavedInOperation)
        }
    }
}

class LoadOperation: Operation {
    enum Errors: Error {
        case profileNotLoadedInOperation
    }
    
    private let completion: (Profile?, Error?) -> Void
    private let fileStorage: FileStorage
    
    init(fileStorage: FileStorage, completion: @escaping (Profile?, Error?) -> Void) {
        self.fileStorage = fileStorage
        self.completion = completion
    }
    
    override func main() {
        guard !isCancelled else { return }
        if let profile = fileStorage.loadProfile() {
            DispatchQueue.main.async {
                self.completion(profile, nil)
            }
        } else {
            DispatchQueue.main.async {
                self.completion(nil, Errors.profileNotLoadedInOperation)
            }
        }
    }
}

class OperationDataManager: ProfileManager {
    private let queue = OperationQueue()
    private let fileStorage = FileStorage()
    
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        let saveOp = SaveOperation(profile: profile, fileStorage: fileStorage, completion: completion)
        queue.addOperation(saveOp)
    }
    
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void) {
        let loadOp = LoadOperation(fileStorage: fileStorage, completion: completion)
        queue.addOperation(loadOp)
    }
}

