//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 05.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData


class CoreDataManager {
    
    private static var _coreDataStack: CoreDataStack?
    public static var coreDataStack: CoreDataStack? {
        get {
            if _coreDataStack == nil {
                _coreDataStack = CoreDataStack.init()
            }
            return _coreDataStack
        }
    }
    
    static func getAppUser() -> AppUser? {
        if let context = self.coreDataStack?.saveContext {
            return self.findOrInsertAppUser(in: context)
        }
        return nil
    }
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error)")
        }
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        return appUser
    }
    
    static func saveUserProfile(_ profile: Profile?, success: Void) {
        if let saveContext = CoreDataManager.coreDataStack?.saveContext {
            guard let appUser = CoreDataManager.findOrInsertAppUser(in: saveContext) else {
                print("appUser finding incorrect")
                return
            }
            appUser.name = profile?.name
            appUser.info = profile?.info
            if profile?.image != nil {
                appUser.image = UIImagePNGRepresentation((profile?.image)!) as Data?
            }
            CoreDataManager.coreDataStack?.performSave(context: (self.coreDataStack?.saveContext)!, completionHandler:{ success })
            
        }
    }
}










