//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 04.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import CoreData

protocol ICoreDataStack: class {
    var saveContext: NSManagedObjectContext? { get }
    var mainContext: NSManagedObjectContext? { get }
    func performSave(context: NSManagedObjectContext, completion: @escaping (Bool, Error?) -> Void)
}

class CoreDataStack: ICoreDataStack {
    
    fileprivate var storeURL: URL {
        get {
            let documentsDirURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirURL.appendingPathComponent("Store.sqlite")
            return url
        }
    }
    
    fileprivate let managedObjectModelName = "Model"
    fileprivate var _managedObjectModel: NSManagedObjectModel?
    fileprivate var managedObjectModel: NSManagedObjectModel? {
        get {
            if _managedObjectModel == nil {
                guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else {
                    print("Empty model url!")
                    return nil
                }
                
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            }
            return _managedObjectModel
        }
    }
    
    fileprivate var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    fileprivate var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            if _persistentStoreCoordinator == nil {
                guard let model = self.managedObjectModel else {
                    print("Empty managed object model")
                    return nil
                }
                
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                
                do {
                    try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                } catch {
                    assert(false, "Error adding persistent store to coordinator: \(error)")
                }
            }
            return _persistentStoreCoordinator
        }
    }
    
    fileprivate var _masterContext: NSManagedObjectContext?
    public var masterContext: NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                    print("Empty persistent store coordenator")
                    return nil
                }
                context.persistentStoreCoordinator = persistentStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            return _masterContext
        }
    }
    
    fileprivate var _mainContext: NSManagedObjectContext?
    var mainContext: NSManagedObjectContext? {
        get {
            if _mainContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("No master context!")
                    return nil
                }
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            return _mainContext
        }
    }
    
    fileprivate var _saveContext: NSManagedObjectContext?
    var saveContext: NSManagedObjectContext? {
        get {
            if _saveContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let parentContext = self.mainContext else {
                    print("No master context!")
                    return nil
                }
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            return _saveContext
        }
    }
    
    public func performSave(context: NSManagedObjectContext, completion: @escaping (Bool, Error?) -> Void) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                    completion(false, error)
                }
                if let parent = context.parent {
                    self?.performSave(context: parent, completion: completion)
                } else {
                    completion(true, nil)
                }
            }
        } else {
            completion(true, nil)
        }
    }
    
    func performSave(in context: NSManagedObjectContext, completionHandler: (() -> Void)?) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                }
                if let parent = context.parent {
                    self.performSave(in: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?()
                }
            } else {
                completionHandler?()
            }
        }
    }
    
}










