//
//  LogoEmittingWindow.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 28.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class LogoEmittingWindow: UIWindow {
    private var logoEmitter: Emitter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        logoEmitter = LogoEmitter(window: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendEvent(_ event: UIEvent) {
        if event.type == .touches, let touches = event.allTouches {
            for touch in touches {
                switch touch.phase {
                case .began:
                    logoEmitter.began(with: touch)
                case .moved:
                    logoEmitter.moved(with: touch)
                case .ended, .cancelled:
                    logoEmitter.ended()
                default:
                    break
                }
            }
        }
        super.sendEvent(event)
    }
}
