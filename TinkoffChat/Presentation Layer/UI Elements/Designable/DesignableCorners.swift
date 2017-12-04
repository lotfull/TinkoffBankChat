//
//  DesignableCorner.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 01/01/2017.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol DesignableCorners {
    var cornerRadius: CGFloat { get set }
    var isCircular: Bool { get set }
    var cornerRadiusFraction: CGFloat { get set }
}

extension DesignableCorners where Self: UIView {
    func setupCorner() {
        let cornerRadius: CGFloat
        if isCircular {
            cornerRadius = bounds.size.width / 2
        } else {
            cornerRadius = self.cornerRadius
        }
        if cornerRadius.isNaN || cornerRadius <= 0 {
            return
        }
        layer.cornerRadius = cornerRadius
    }
    
    func setupCorners() {
        let cornerRadius: CGFloat
        if isCircular {
            cornerRadius = bounds.size.height / 2
        } else {
            let cornerRadiusIsValid = !self.cornerRadiusFraction.isNaN && self.cornerRadiusFraction > 0 && self.cornerRadiusFraction <= 1
            if cornerRadiusIsValid {
                cornerRadius = bounds.size.width * cornerRadiusFraction
            } else {
                cornerRadius = self.cornerRadius
            }
        }
        if cornerRadius.isNaN || cornerRadius <= 0 {
            return
        }
        layer.cornerRadius = cornerRadius
    }
}
