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

    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ChatsListViewController_")
        
        let controller = rootAssembly.ChatsListModule.ChatsListViewControllerr()
        
        window?.rootViewController = controller// initialViewController//controller
        window?.makeKeyAndVisible()
        return true
    }
   
    
}

