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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /*if let rootNavigationController = window!.rootViewController
            as? UINavigationController,
            let conversationListVC = rootNavigationController.topViewController as? ConversationsListViewController {
            conversationListVC.managedObjectContext = managedObjectContext
            
            clearAllData()
            for i: Bool in [false, true] {
                for j: Bool in [false, true] {
                    for k: Bool in [false, false, true] {
                        for online: Bool in [false, true] {
                            for hasUnreadMessages: Bool in [false, true] {
                                let chat = Chat(context: managedObjectContext)
                                chat.date = i ? NSDate() : NSDate(timeIntervalSinceNow: TimeInterval(arc4random_uniform(234567)))
                                chat.name = j && chat.hash % 10 == 0 ? nil : "Petr \(chat.hash % 10)"
                                chat.message = k ? nil : "message \(chat.hashValue % 10)"
                                chat.online = online
                                chat.hasUnreadMessages = hasUnreadMessages
                            }
                        }
                    }
                }
            }
            let defaultText1 = "L"
            let defaultText30 = "Lorem ipsum dolor sit posuere."
            let defaultText300 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur et nunc ac lorem fringilla iaculis sed eget mauris. Nulla ut libero ac arcu facilisis faucibus ut id elit. Vivamus quam velit, vehicula vitae lobortis eu, maximus quis elit. Morbi ut nulla maximus mi condimentum tempor viverra fusce."
            for text in [defaultText1, defaultText30, defaultText300] {
                for bool in [false, true] {
                    let message = Message(context: managedObjectContext)
                    message.name = "DefaultName"
                    message.text = text
                    message.isInbox = bool
                }
            }
        }*/
        return true
    }
   
}

