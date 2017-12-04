//
//  Extensions.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 01.12.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

public protocol Iteratable { }

public extension Iteratable where Self: RawRepresentable, Self: Hashable {
    
    public static func hashValues() -> AnyIterator<Self> {
        return iterateEnum(self)
    }
    
    public static func rawValues() -> [Self.RawValue] {
        return hashValues()
            .map { $0.rawValue }
    }
    
    public static func cases() -> [Self] {
        return Array(hashValues())
    }
    
}

public extension RawRepresentable where Self: RawRepresentable {
    
    public static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        
        return AnyIterator {
            let next = withUnsafePointer(to: &i) {
                $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
            }
            
            if next.hashValue != i {
                return nil
            }
            
            i += 1
            
            return next
        }
    }
    
}

public extension UIView {
    
    public enum Edge: Int, Iteratable {
        case top = 1000, left, bottom, right
    }
    
    public func addLine(to edge: Edge,
                        insets: UIEdgeInsets = .zero,
                        color: UIColor,
                        thickness: CGFloat = 0.5) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.tag = edge.rawValue
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        let topConstraint = NSLayoutConstraint(
            item: lineView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: insets.top
        )
        
        let leftConstraint = NSLayoutConstraint(
            item: lineView,
            attribute: .left,
            relatedBy: .equal,
            toItem: self,
            attribute: .left,
            multiplier: 1,
            constant: insets.left
        )
        
        let bottomConstraint = NSLayoutConstraint(
            item: lineView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: -insets.bottom
        )
        
        let rightConstraint = NSLayoutConstraint(
            item: lineView,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1,
            constant: -insets.right
        )
        
        let heightConstraint = NSLayoutConstraint(
            item: lineView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: thickness
        )
        
        let widthConstraint = NSLayoutConstraint(
            item: lineView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: thickness
        )
        
        switch edge {
        case .top:
            NSLayoutConstraint.activate(
                [
                    topConstraint,
                    leftConstraint,
                    rightConstraint,
                    heightConstraint
                ]
            )
        case .left:
            NSLayoutConstraint.activate(
                [
                    topConstraint,
                    leftConstraint,
                    bottomConstraint,
                    widthConstraint
                ]
            )
        case .bottom:
            NSLayoutConstraint.activate(
                [
                    leftConstraint,
                    bottomConstraint,
                    rightConstraint,
                    heightConstraint
                ]
            )
        case .right:
            NSLayoutConstraint.activate(
                [
                    topConstraint,
                    rightConstraint,
                    bottomConstraint,
                    widthConstraint
                ]
            )
        }
    }
    
    /**
     Removes all lines (subviews added with `addLine(to:insets:color:thickness:)`
     method) of first level depth.
     */
    func removeLines() {
        let lineTags = Edge.cases().map { $0.rawValue }
        
        subviews.forEach {
            if lineTags.contains($0.tag) {
                $0.removeFromSuperview()
            }
        }
    }
    
}
