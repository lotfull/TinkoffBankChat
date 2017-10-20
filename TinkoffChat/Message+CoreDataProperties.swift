//
//  Message+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 08.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var text: String?
    @NSManaged public var name: String?
    @NSManaged public var isInbox: Bool

}
