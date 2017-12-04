//
//  CustomKerningLabel.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 01/01/2017.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

@IBDesignable class CustomKerningLabel: UILabel {
    @IBInspectable var characterSpacing: CGFloat = 1 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSAttributedStringKey.kern,
                                          value: self.characterSpacing,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            self.attributedText = attributedString
        }
    }
}
