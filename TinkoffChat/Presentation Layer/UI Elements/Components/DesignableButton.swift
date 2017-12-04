//
//  DesignableButton.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 01/01/2017.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton, DesignableCorners, DesignableBorder, DesignableBackgroundColor {

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

    // MARK: - Border
    @IBInspectable var borderWidth: CGFloat = CGFloat.nan {
        didSet {
            setupBorder()
        }
    }

    @IBInspectable var borderColor: UIColor? = nil {
        didSet {
            setupBorder()
        }
    }

    // MARK: - Background color
    @IBInspectable var disabledAdjustsBackgroundColor: Bool = false {
        didSet {
            setupBackgroundColor()
        }
    }

    @IBInspectable var normalBackgroundColor: UIColor? = .white {
        didSet {
            setupBackgroundColor()
        }
    }

    @IBInspectable var disabledBackgroundColor: UIColor? = .gray {
        didSet {
            setupBackgroundColor()
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        setupBackgroundColor()
        setupCorners()
        setupBorder()
    }
}
