//
//  BorderTextNode.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 21.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SpriteKit

class BorderTextNode : SKLabelNode {
    private let borderRight : SKLabelNode
    private let borderLeft : SKLabelNode
    private let borderTop : SKLabelNode
    private let borderBot : SKLabelNode
    private let offset = 1
    
    var borderColor : UIColor = .white {
        didSet {
            borderRight.fontColor = borderColor
            borderLeft.fontColor = borderColor
            borderTop.fontColor = borderColor
            borderBot.fontColor = borderColor
        }
    }
    
    var textSize : CGFloat  = 0 {
        didSet{
            self.fontSize = textSize
            borderRight.fontSize = textSize
            borderLeft.fontSize = textSize
            borderTop.fontSize = textSize
            borderBot.fontSize = textSize
        }
    }
    
    init(text: String, fontSize: CGFloat, fontColor: UIColor, fontName: String, borderColor: UIColor) {
        borderRight = SKLabelNode(text: text)
        borderLeft = SKLabelNode(text: text)
        borderTop = SKLabelNode(text: text)
        borderBot = SKLabelNode(text: text)
        
        super.init()
        
        self.text = text
        self.fontSize  = fontSize
        self.fontColor = fontColor
        self.fontName = fontName
        self.horizontalAlignmentMode = .right
        
        borderRight.fontSize  = fontSize
        borderRight.fontColor = borderColor
        borderRight.fontName = fontName
        borderRight.zPosition = -1
        borderRight.position = CGPoint(x: offset, y: 0)
        borderRight.horizontalAlignmentMode = .right
        
        borderLeft.fontSize  = fontSize
        borderLeft.fontColor = borderColor
        borderLeft.fontName = fontName
        borderLeft.zPosition = -1
        borderLeft.position = CGPoint(x: -offset, y: 0)
        borderLeft.horizontalAlignmentMode = .right
        
        borderTop.fontSize  = fontSize
        borderTop.fontColor = borderColor
        borderTop.fontName = fontName
        borderTop.zPosition = -1
        borderTop.position = CGPoint(x: 0, y: offset * 3)
        borderTop.horizontalAlignmentMode = .right
        
        borderBot.fontSize  = fontSize
        borderBot.fontColor = borderColor
        borderBot.fontName = fontName
        borderBot.zPosition = -1
        borderBot.position = CGPoint(x: 0, y: -offset)
        borderBot.horizontalAlignmentMode = .right
        
        self.addChild(borderRight)
        self.addChild(borderLeft)
        self.addChild(borderTop)
        self.addChild(borderBot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(to text: String, withAnimation: Bool = false) {
        if withAnimation {
            addPositiveAnimation()
        }
        self.text = text
        borderRight.text = text
        borderLeft.text = text
        borderTop.text = text
        borderBot.text = text
    }
    
    func addPositiveAnimation() {
        let increaseSize = SKAction.scale(by: 1.2, duration: 0.4)
        let decreaseSize = SKAction.scale(to: self.frame.size, duration: 0.4)
        self.run(SKAction.sequence([increaseSize, decreaseSize]))
    }
    
    func addNegativeAnimation() {
        let decreaseSize = SKAction.scale(by: 0.8, duration: 0.4)
        let increaseSize = SKAction.scale(to: self.frame.size, duration: 0.4)
        self.run(SKAction.sequence([decreaseSize, increaseSize]))
    }
}
