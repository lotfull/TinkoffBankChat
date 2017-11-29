//
//  LogoEmitter.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 28.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import Foundation

protocol Emitter {
    func began(with touch: UITouch)
    func moved(with touch: UITouch)
    func ended()
}

class LogoEmitter: Emitter {
    private weak var window: UIWindow?
    private lazy var emitterLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "logo").cgImage
        cell.emissionRange = 2 * .pi
        cell.emissionLongitude = .pi
        cell.emissionLatitude = .pi
        cell.birthRate = 30
        cell.lifetime = 0.5
        cell.lifetimeRange = 0.5
        cell.velocity = 40
        cell.velocityRange = 20
        cell.spin = 0
        cell.spinRange = 4 * .pi
        cell.scale = 0.5
        cell.scaleRange = 0.2
        cell.color = UIColor.white.cgColor;
        cell.redRange = 0.5;
        cell.greenRange = 0.5;
        cell.blueRange = 0.5;
        cell.alphaRange = 0.5;
        emitterLayer.emitterCells = [cell]
        emitterLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        emitterLayer.birthRate = 0
        return emitterLayer
    }()

    init(window: UIWindow) {
        self.window = window
        window.layer.addSublayer(emitterLayer)
    }
    
    func began(with touch: UITouch) {
        emitterLayer.birthRate = 1
        moved(with: touch)
    }
    
    func moved(with touch: UITouch) {
        let location = touch.location(in: window)
        emitterLayer.emitterPosition = location
    }
    
    func ended() {
        emitterLayer.birthRate = 0
    }
    
}
