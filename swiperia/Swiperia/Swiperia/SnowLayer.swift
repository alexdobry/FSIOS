//
//  ComboBorderLayer.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 23.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SceneKit

class SnowLayer : CALayer {
    let topEmitter = CAEmitterLayer()
    let leftEmitter = CAEmitterLayer()
    let rightEmitter = CAEmitterLayer()
    
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        
        //Create the border emitter layer
        topEmitter.emitterShape = kCAEmitterLayerLine
        topEmitter.emitterSize = CGSize(width: frame.width, height: 1)
        topEmitter.emitterPosition = CGPoint(x: frame.width / 2, y: 0)
        topEmitter.renderMode = kCAEmitterLayerAdditive
        
        rightEmitter.emitterShape = kCAEmitterLayerLine
        rightEmitter.emitterSize = CGSize(width: frame.width, height: 1)
        rightEmitter.emitterPosition = CGPoint(x: frame.width, y: 0)
        rightEmitter.renderMode = kCAEmitterLayerAdditive
        
        leftEmitter.emitterShape = kCAEmitterLayerLine
        leftEmitter.emitterSize = CGSize(width: frame.width, height: 1)
        leftEmitter.emitterPosition = CGPoint(x: 0, y: 0)
        leftEmitter.renderMode = kCAEmitterLayerAdditive
        
        topEmitter.emitterCells = (0..<15).map({ _ in
            let intensity = Float(1)
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 60.0 * intensity
            cell.lifetime = 2 * intensity
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(350.0 * intensity)
            cell.velocityRange = CGFloat(80.0 * intensity)
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = CGFloat(Double.pi / 4)
            cell.spin = CGFloat(3.5 * intensity)
            cell.spinRange = CGFloat(4.0 * intensity)
            cell.scale = 0.1
            cell.scaleRange = CGFloat(intensity)
            cell.scaleSpeed = CGFloat(-0.1 * intensity)
            cell.contents = UIImage(named: "spark")!.cgImage
            
            return cell
        })
        
        rightEmitter.emitterCells = (0..<15).map({ _ in
            let intensity = Float(1)
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 60.0 * intensity
            cell.lifetime = 2 * intensity
            cell.yAcceleration = 50
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(350.0 * intensity)
            cell.velocityRange = CGFloat(80.0 * intensity)
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = CGFloat(Double.pi / 4)
            cell.spin = CGFloat(3.5 * intensity)
            cell.spinRange = CGFloat(4.0 * intensity)
            cell.scale = 0.1
            cell.scaleRange = CGFloat(intensity)
            cell.scaleSpeed = CGFloat(-0.1 * intensity)
            cell.contents = UIImage(named: "spark")!.cgImage
            
            return cell
        })
        
        leftEmitter.emitterCells = (0..<15).map({ _ in
            let intensity = Float(1)
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 60.0 * intensity
            cell.lifetime = 2 * intensity
            cell.yAcceleration = 50
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(350.0 * intensity)
            cell.velocityRange = CGFloat(80.0 * intensity)
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = CGFloat(Double.pi / 4)
            cell.spin = CGFloat(3.5 * intensity)
            cell.spinRange = CGFloat(4.0 * intensity)
            cell.scale = 0.1
            cell.scaleRange = CGFloat(intensity)
            cell.scaleSpeed = CGFloat(-0.1 * intensity)
            cell.contents = UIImage(named: "spark")!.cgImage
            
            return cell
        })
        
        self.addSublayer(topEmitter)
        self.addSublayer(rightEmitter)
        self.addSublayer(leftEmitter)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
