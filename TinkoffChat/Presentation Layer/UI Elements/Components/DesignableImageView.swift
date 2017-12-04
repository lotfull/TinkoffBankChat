//
//  DesignableImageView.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 01/01/2017.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

@IBDesignable class DesignableImageView: UIImageView, DesignableCorners {

    // MARK: - Corners
    @IBInspectable var cornerRadius: CGFloat = .nan {
        didSet {
            setupCorners()
        }
    }

    @IBInspectable var isCircular: Bool = false {
        didSet {
            setupCorners()
        }
    }

    @IBInspectable var cornerRadiusFraction: CGFloat = .nan {
        didSet {
            setupCorners()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCorners()
    }
}
