//
//  ProfileImageCell.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ProfileImageCell: UICollectionViewCell {
    class var identifier: String {
        return String(describing: self)
    }
    
    var hasLoadedImage = false
    
    var image: UIImage? {
        didSet {
            profileImageView.image = image
        }
    }
    
    var indexPath: IndexPath?
    
    @IBOutlet private weak var profileImageView: UIImageView!
}

