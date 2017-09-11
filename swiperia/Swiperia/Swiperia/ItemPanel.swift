//
//  ItemPanel.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 16.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SpriteKit

protocol ItemPanelDelegate : class {
    func clicked(name: String)
}

class ItemPanel : SKSpriteNode, Pausable {
    weak var delegate : ItemPanelDelegate?
    
    let width : CGFloat
    let height : CGFloat
    let panelName : String
    var glowColor : UIColor
    
    private let pulseInterval : Double = 2.0
    private let transperancy : CGFloat = 0.9
    private let reduceFactor : CGFloat = 15
    private let startAngle = CGFloat(.pi / 2.0)
 
    init(name: String, size: CGSize, textureName: String, glowColor: UIColor, _ manifestTime: Double? = nil) {
        panelName = name
        width = size.width
        height = size.height
        self.glowColor = glowColor
        
        let image = UIImage(named: textureName)
        
        let texture = SKTexture(image: image!)
        
        let borderNode = SKShapeNode()
        borderNode.path = UIBezierPath(
            roundedRect: CGRect.init(x: -width/2, y: -height/2, width: width, height: height),
            cornerRadius: 15
        ).cgPath
        borderNode.strokeColor = glowColor
        borderNode.lineWidth = width / reduceFactor
        borderNode.fillColor = .white
        borderNode.fillTexture = texture
        borderNode.glowWidth = width / reduceFactor
        borderNode.name = "borderNode"
        borderNode.alpha = transperancy
        
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
        colorNode.name = "colorNode"
        
        borderNode.addChild(colorNode)
        
        let newTexture = SKView().texture(from: borderNode)
        
        
        super.init(texture: newTexture, color: .black, size: size)
        
        if let manifestTime = manifestTime {
            self.xScale = 0
            self.yScale = 0.01
            appear(in: manifestTime)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPulse() {
        let reduceOpacity = SKAction.fadeAlpha(to: transperancy / 2, duration: pulseInterval)
        reduceOpacity.timingMode = SKActionTimingMode.easeInEaseOut
            
        let increaseOpacity = SKAction.fadeAlpha(to: transperancy, duration: pulseInterval)
        increaseOpacity.timingMode = SKActionTimingMode.easeInEaseOut
                    
        self.run(SKAction.repeatForever(SKAction.sequence([reduceOpacity,increaseOpacity])))
    }
    
    func addRotation() {
        let rotateRight = SKAction.rotate(toAngle: -2 * CGFloat((Double.pi) / 180), duration: 0.5)
        rotateRight.timingMode = SKActionTimingMode.linear
        
        let rotateLeft = SKAction.rotate(toAngle: 2 * CGFloat((Double.pi) / 180), duration: 0.5)
        rotateLeft.timingMode = SKActionTimingMode.linear
        
        self.run(SKAction.repeatForever(SKAction.sequence([rotateRight,rotateLeft])))
    }
    
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
    
    func addTimer(with seconds: Double) {
        self.children.forEach {
            $0.removeAllActions()
            $0.removeFromParent()
        }
        
        let maskShape = SKShapeNode()
        let height = self.height - self.width / (reduceFactor / 1.5)
        let width = self.width - self.width / (reduceFactor / 1.5)
        maskShape.path = UIBezierPath(
            roundedRect: CGRect.init(x: -width/2, y: -height/2, width: width, height: height),
            cornerRadius: 15
        ).cgPath
        maskShape.fillColor = .white
        maskShape.lineWidth = 0
        
        let mask = SKView().texture(from: maskShape)
        let maskNode = SKSpriteNode()
        maskNode.color = .white
        maskNode.texture = mask
        maskNode.size = CGSize(width: width, height: height)
        maskNode.blendMode = .multiply
        
        let timerMask = SKCropNode()
        timerMask.name = "timerMask"
        timerMask.maskNode = maskNode
        
        self.addChild(timerMask)
        
        let timeProgress = SKSpriteNode()
        timeProgress.color = glowColor
        timeProgress.alpha = 0.5
        timeProgress.size = CGSize(width: width, height: height)
        timeProgress.position = CGPoint(x: 0, y: height)
        timeProgress.name = "timeProgress"
        
        let moveDown = SKAction.move(to: CGPoint.zero, duration: seconds)
        timeProgress.run(moveDown)
        
        timerMask.addChild(timeProgress)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPaused {
            delegate?.clicked(name: panelName)
        }
    }
    
    func pause() {
        self.childNode(withName: "timeProgress")?.isPaused = true
        self.isPaused = true
    }
    
    func resume() {
        self.childNode(withName: "timeProgress")?.isPaused = false
        self.isPaused = false
    }
}
