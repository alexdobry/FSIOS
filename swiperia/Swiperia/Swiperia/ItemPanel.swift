//
//  ItemPanel.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 16.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SpriteKit

protocol ItemPanelDelegate : class {
    func clicked(name: String)
}


class ItemPanel : SKShapeNode {
    
    weak var delegate : ItemPanelDelegate?
    
    let borderNode : SKShapeNode
    let width : CGFloat
    let height : CGFloat
    let panelName : String
    
    let pulseInterval : Double = 3.0
    let transperancy : CGFloat = 0.9
    let reduceFactor : CGFloat = 15
    
    /// Init-Function
    init(name: String, size: CGSize, textureName: String, glowColor: UIColor, _ manifestTime: Double? = nil) {
        panelName = name
        width = size.width
        height = size.height
        borderNode = SKShapeNode()
        
        super.init()
        
        self.xScale = 0
        self.yScale = 0.01
        
        guard let image = UIImage(named: textureName) else {return}
        let texture = SKTexture(image: image)
        let path = UIBezierPath(
            roundedRect: CGRect.init(x: -width/2, y: -height/2, width: width, height: height),
            cornerRadius: 15
            ).cgPath
        self.path = path
        self.lineWidth = 0
        self.isAntialiased = true
        self.alpha = transperancy
        
        borderNode.path = path
        borderNode.strokeColor = glowColor
        borderNode.lineWidth = width / reduceFactor
        borderNode.fillColor = .white
        borderNode.fillTexture = texture
        borderNode.glowWidth = width / reduceFactor
        borderNode.name = "borderNode"
        
        let colorNode = SKShapeNode()
        let sWidth = width - width / (reduceFactor / 1.5)
        let sHight = height - width / (reduceFactor / 1.5)
        colorNode.path = UIBezierPath(
            roundedRect: CGRect.init(x: -sWidth/2, y: -sHight/2, width: sWidth, height: sHight),
            cornerRadius: 15
            ).cgPath
        colorNode.lineWidth = width / (reduceFactor / 2)
        colorNode.strokeColor = .black
        colorNode.fillColor = glowColor
        colorNode.blendMode = .multiplyX2
        colorNode.isAntialiased = false
        colorNode.lineCap = CGLineCap(rawValue: 1)!
        
        if let manifestTime = manifestTime {
            appear(in: manifestTime)
        }
        
        self.addChild(borderNode)
        borderNode.addChild(colorNode)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    func addPulse() {
        let reduceOpacity = SKAction.fadeAlpha(to: transperancy / 2, duration: pulseInterval)
        reduceOpacity.timingMode = SKActionTimingMode.easeInEaseOut
        
        let increaseOpacity = SKAction.fadeAlpha(to: transperancy, duration: pulseInterval)
        increaseOpacity.timingMode = SKActionTimingMode.easeInEaseOut
        
        self.run(SKAction.repeatForever(SKAction.sequence([reduceOpacity,increaseOpacity])))
    }
    
    ///
    func addRotation() {
        let rotateRight = SKAction.rotate(toAngle: -2 * CGFloat((Double.pi) / 180), duration: 0.5)
        rotateRight.timingMode = SKActionTimingMode.linear
        
        let rotateLeft = SKAction.rotate(toAngle: 2 * CGFloat((Double.pi) / 180), duration: 0.5)
        rotateLeft.timingMode = SKActionTimingMode.linear
        
        self.run(SKAction.repeatForever(SKAction.sequence([rotateRight,rotateLeft])))
    }
    
    ///
    private func appear(in seconds: Double) {
        self.removeAllActions()
        let adjustWidth = SKAction.scaleX(to: 1, duration: seconds / 2)
        let adjustHeight = SKAction.scaleY(to: 1, duration: seconds / 2)
        self.run(adjustWidth)
        
        let when = DispatchTime.now() + seconds / 2
        DispatchQueue.main.asyncAfter(deadline: when) {[weak self] in
            guard let strongS = self else {return}
            strongS.run(adjustHeight)
        }
    }
    
    ///
    func disappear(in seconds: Double) {
        self.removeAllActions()
        let adjustWidth = SKAction.scaleX(to: 0, duration: seconds / 2)
        let adjustHeight = SKAction.scaleY(to: 0.01, duration: seconds / 2)
        self.run(adjustHeight)
        
        let when = DispatchTime.now() + seconds / 2
        DispatchQueue.main.asyncAfter(deadline: when) {[weak self] in
            guard let strongS = self else {return}
            strongS.run(adjustWidth)
        }
    }
    
    ///
    func addTimer(with seconds: Double) {
        //TODO: Here some stuff
    }
    
    ///
    deinit {
        borderNode.removeAllChildren()
        borderNode.removeFromParent()
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    ///
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.clicked(name: panelName)
    }
}
