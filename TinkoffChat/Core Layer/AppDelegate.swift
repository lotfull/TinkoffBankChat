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

    let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = LogoEmittingWindow(frame: UIScreen.main.bounds)
        let controller = rootAssembly.ChatsListModule.chatsListViewController()
        let navigationController = UINavigationController.init(rootViewController: controller)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}











