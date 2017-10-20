//
//  Chat+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var message: String?
    @NSManaged public var name: String?
    @NSManaged public var hasUnreadMessages: Bool
    @NSManaged public var online: Bool
    @NSManaged public var date: NSDate?

}
