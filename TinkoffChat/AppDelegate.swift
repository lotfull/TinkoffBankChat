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

    func logFunctionName(string: String = #function) {
        print(string)
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        logFunctionName()
        /*
        window = UIWindow.init(frame: UIScreen.main.bounds) // Задаем виндоу размером с экран
        if let keyWindow = window {
            keyWindow.rootViewController = ProfileVC()
            keyWindow.makeKeyAndVisible() // making our self created window visible
        }
        */
        
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

