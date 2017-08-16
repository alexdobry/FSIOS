//
//  ProgressCircle.swift
//  Swiperia
//
//  Created by Edgar Gellert on 14.08.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import Foundation
import SpriteKit

class ProgressCircle: SKShapeNode {
    
//MARK: Properties
    private var radius : CGFloat
    private let startAngle = CGFloat(.pi/2.0)
    var barColor : UIColor {
        didSet {
            strokeColor = barColor
        }
    }
    
    
//MARK: Functions
    init(radius: CGFloat, barWidth: CGFloat, barColor: UIColor) {
        self.radius = radius
        self.barColor = barColor
        
        super.init()
        self.lineWidth = barWidth
        
        updateProgress(to: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgress(to percentage: CGFloat) {
        let endAngle = startAngle + (percentage * CGFloat(2.0 * .pi))
        self.path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false).cgPath
    }
    
}
