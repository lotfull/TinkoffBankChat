//
//  AppUser.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 04.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import CoreData

extension AppUser {
    
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let requestName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: requestName) as? NSFetchRequest<AppUser> else {
            assert(false, "No fetch request template with name \(requestName)")
            return nil
        }
        return fetchRequest
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser {
            if appUser.currentUser == nil {
                let currentUser = User.findOrInsertUser(withID: User.generateUserIDString(), in: context)
                appUser.currentUser = currentUser
            }
            return appUser
        }
        return nil
    }
}
