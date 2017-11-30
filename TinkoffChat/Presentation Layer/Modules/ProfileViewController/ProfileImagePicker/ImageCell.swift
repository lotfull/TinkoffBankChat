//
//  ImageCell.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    class var identifier: String {
        return String(describing: self)
    }
    
    var hasLoadedImage = false
    var indexPath: IndexPath?
    
    @IBOutlet weak var imageView: UIImageView!
}

