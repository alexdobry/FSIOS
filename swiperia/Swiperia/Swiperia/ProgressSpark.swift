//
//  ProgressCircle.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 14.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SpriteKit

class ProgressSpark: SKSpriteNode {
    
    private let radius : CGFloat
    private let startAngle = CGFloat(.pi / 2.0)
    var sparkShouldAppear = false
    private var spark : SKEmitterNode
    private var barWidth : CGFloat
    
    init(radius: CGFloat, barWidth: CGFloat) {
        self.radius = radius
        self.barWidth = barWidth
        spark = SKEmitterNode(fileNamed: "Spark.sks")!
        spark.particleSize.height = barWidth * 7
        spark.particleSize.width = barWidth * 7
        spark.alpha = 0.3
        super.init(texture: nil, color: .clear, size: CGSize(width: radius * 2, height: radius * 2))
        self.alpha = 0.3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgress(to percentage: CGFloat) {
        if percentage <= 0 {
            spark.removeFromParent()
        } else {
            if sparkShouldAppear {
                if spark.parent == nil {
                    self.addChild(spark)
                }
                
                let endAngle   = startAngle - percentage * CGFloat(2.0 * .pi)
                let newPosition = CGPoint(x: cos(endAngle) * radius, y: sin(endAngle) * radius)
                spark.position = newPosition
                spark.zRotation = endAngle - startAngle
            }
        }
    }
}
