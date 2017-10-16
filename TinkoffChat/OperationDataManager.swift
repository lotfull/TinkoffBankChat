//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 16.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import UIKit

class OperationDataManager: OperationDelegate {
    func saveObjects(_ objects: [Any?], toFile: String) -> Bool {
        return true
    }
    
    
    /*var operationQueue = OperationQueue()
    
    let operation1 = BlockOperation ({
        self.doCalculations()
    })
    operationQueue.addOperation(operation1)

func doCalculations(){
    NSLog("do Calculations")
    for i in 100...105{
        println("i in do calculations is \(i)")
        sleep(1)
    }
}
    
    let queue = DispatchQueue(label: "editProfileWithGCD.queue")
    func saveObjects(_ objects: [Any?], toFile: String) -> Bool {
        return NSKeyedArchiver.archiveRootObject(objects, toFile: toFile)
    }*/
    
}

