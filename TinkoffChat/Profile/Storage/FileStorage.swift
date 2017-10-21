FileStorage//
//  File.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 21.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class FileStorage {
    var objects = [Any?]()
    var newChanges = false
    
    var lastMethod: String = "Opening VC"
    var keyboardSize: CGRect? = nil
    var show: CGFloat = 1.0
    var cornerRadius: CGFloat = 0.0
    var activeTextField: UITextField?
    
    private func serialize(_ profile: Profile) -> [String: Any] {
        
    }
    
//    let objects = [image, name, info] as [Any?]
    
//    if let array = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Any?] {
//        objects = array
//        if let photo = objects[photo] as? UIImage?,
//            let name = objects[name] as? String?,
//            let info = objects[info] as? String? {
//            photoImageView.image = photo
//            nameTextField.text = name
//            infoTextField.text = info
//        }
//    }
    
//    // MARK: - API
//    func saveProfile(_ profile: Profile) throws {
//        let dataDic
//    }
    
    // MARK: - Vars
    private var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        return (url.appendingPathComponent(FileStorage.fileName)?.path)!
    }
    private let fileManager = FileManager.default
    private static let fileName = "profileData"
    private static let profileNameKey = "profileName"
    private static let profileInfoKey = "profileInfo"
    private static let profileImageKey = "profileImage"
    let photo = 0, name = 1, info = 2
}

