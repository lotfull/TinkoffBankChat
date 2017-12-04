//
//  sendButton.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 01.12.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class SendButton: UIButton {
    
    private let enabledColor = UIColor(red: 42, green: 124, blue: 251, alpha: 1)
    private let disabledColor = UIColor.lightGray
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = bounds.width / 2
    }
    
    override var isEnabled: Bool {
        didSet {
            let newColor = isEnabled ? enabledColor : disabledColor
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: [.allowUserInteraction],
                animations: {
                    self.tintColor = newColor
                    self.transform = CGAffineTransform(scaleX: 1.15,
                                                       y: 1.15)
            }) { _ in
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    options: [.allowUserInteraction],
                    animations: {
                        self.transform = .identity
                })
            }
        }
    }
    
}
