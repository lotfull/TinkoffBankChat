//
//  User.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 04.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

extension User {
    static func findOrInsertUser(withID id: String, in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        var user: User?
        guard let fetchRequest = User.fetchRequestUserByID(model: model, id: id) else {
            return nil
        }
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple Users found!")
            print("*** user results\n", results)
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("Failed to fetch User: \(error)")
        }
        if user == nil {
            print(#function, "user == nil")
            user = User.insertUser(with: id, in: context)
        }
        return user
    }
    
    private static func insertUser(with id: String, in context: NSManagedObjectContext) -> User? {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
        user?.id = id
        user?.name = User.generateCurrentUserNameString()
        return user
    }
    
    private static func fetchRequestUserByID(model: NSManagedObjectModel, id: String) -> NSFetchRequest<User>? {
        let requestName = "UserByID"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: requestName, substitutionVariables: [id: id]) as? NSFetchRequest<User> else {
            assert(false, "No fetch request template with name \(requestName)")
            return nil
        }
        return fetchRequest
    }
    
    private static func generateCurrentUserNameString() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    static func generateUserIDString() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
}















