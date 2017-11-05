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

    fileprivate let rootAssembly = RootAssembly()
//    lazy var coreDataStack = CoreDataStack(modelName: "SurfJournalModel")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = rootAssembly.ChatsListModule.chatsListViewController()
        let navigationController = UINavigationController.init(rootViewController: controller)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        guard let chatsListViewController = navigationController.topViewController as? ChatsListViewController else {
            fatalError("Application Storyboard mis-configuration")
        }
        chatsListViewController.coreDataStack = coreDataStack
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
}











