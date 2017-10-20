//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 16.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: GCDDelegate {
    let queue = DispatchQueue(label: "editProfileWithGCD.queue")
    func saveObjects(_ objects: [Any?], toFile: String) -> Bool {
        return NSKeyedArchiver.archiveRootObject(objects, toFile: toFile)
    }
    
}
