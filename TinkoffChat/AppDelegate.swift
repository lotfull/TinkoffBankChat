//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.09.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var lastState: String? = "Launching"

    func logFunctionName(string: String = #function) {
        let newState = UIApplication.shared.applicationState
        var newStateString: String
        switch newState {
        case .active:
            newStateString = "Active"
        case .background:
            newStateString = "Background"
        case .inactive:
            newStateString = "Inactive"
        }
        print("Application moved from \(lastState!) to \(newStateString) with method: \(string)")
        lastState = newStateString
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        logFunctionName()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) { // приложение при интеракции переходит в этот режим(при звонке)
        logFunctionName()
    }
    
    // аппдлегат также помогает слушать notifications
    // основные элементы uiview и uiviewC, от них все наследуются
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        logFunctionName()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logFunctionName()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        logFunctionName()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        logFunctionName()
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TinkoffChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

