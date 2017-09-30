//
//  InformationOverlayScene.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 04.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SpriteKit

protocol OverlaySceneDelegate : class {
    func ownItemFired(_ item : Item)
    func opponentItemShown(_ item : Item)
}

class OverlayScene: SKScene, Pausable {
    var gameScore : BorderTextNode?
    
    var scoreMultiplicator : BorderTextNode?
    
    weak var overlayDelegate : OverlaySceneDelegate?

    var playerItem : Item? {
        willSet {
            if newValue == nil {
                guard let playerItem = playerItem, let playerItemNode = self.childNode(withName: "playerItem") else {return}
                playerItemNode.removeFromParent()
                overlayDelegate?.ownItemFired(playerItem)
            } else {
                if playerItem == nil {
                    let playerItemNode = ItemPanel(name: "playerItem", size: CGSize(width: width / (Constants.SPRITEKIT_MINIMIZE_FACTOR) , height: width / (Constants.SPRITEKIT_MINIMIZE_FACTOR)), textureName: newValue!.imageName, glowColor: positiveColor, Constants.ITEM_MANIFEST_TIME)
                
                    playerItemNode.position = CGPoint(x: width / 2, y: height / 2)
                    playerItemNode.name = "playerItem"
                    playerItemNode.addPulse()
                    self.addChild(playerItemNode)
                
                    playerItemNode.isUserInteractionEnabled = true
                    playerItemNode.delegate = self
                }
            }
        }
    }
    
    fileprivate var appearTime : Double {
        get {
            return Constants.ITEM_MANIFEST_TIME + Constants.ITEM_SHOW_TIME
        }
    }
    
    fileprivate var moveTime : Double {
        get {
            return appearTime + Constants.ITEM_MOVE_TIME
        }
    }
    
    fileprivate var opponentItemTimer : TimeManager?
    
    fileprivate var opponentItem : Item?
    
    fileprivate var opponentItemNode : ItemPanel?
    
    let width : CGFloat
    let height : CGFloat
    let positiveColor : UIColor
    let negativeColor : UIColor
    
    init(size: CGSize, positiveColor: UIColor, negativeColor: UIColor, _ showScoreOverlay : Bool) {
        self.width = size.width
        self.height = size.height
        self.positiveColor = positiveColor
        self.negativeColor = negativeColor

        super.init(size: size)
        
        if showScoreOverlay { appendScoreOverlay() }
        
        self.isUserInteractionEnabled = false
        self.scaleMode = .resizeFill
    }
    
    func appendScoreOverlay() {
        self.gameScore = BorderTextNode(text: "0", fontSize: height / 15, fontColor: .white, fontName: "HelveticaNeue-BoldItalic", borderColor: .clear)
        self.gameScore!.zPosition = 2
        self.scoreMultiplicator = BorderTextNode(text: "x1", fontSize: height / 20, fontColor: positiveColor, fontName: "HelveticaNeue-BoldItalic", borderColor: .clear)
        self.scoreMultiplicator!.zPosition = 2
        
        self.scoreMultiplicator!.position = CGPoint(x: width * 0.99, y: height - gameScore!.frame.height * 1.5)
        self.addChild(scoreMultiplicator!)
        
        self.gameScore!.position = CGPoint(x: width * 0.99 - scoreMultiplicator!.frame.width * 1.9, y: height - gameScore!.frame.height * 1.5)
        self.addChild(gameScore!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showOpponentItem(_ item: Item, _ timerList: [TimeManager]?) {
        opponentItem = item
        opponentItemNode = ItemPanel(name: "opponentItem", size: CGSize(width: width / (Constants.SPRITEKIT_MINIMIZE_FACTOR / 1.1) , height: width / (Constants.SPRITEKIT_MINIMIZE_FACTOR / 1.1)), textureName: item.imageName, glowColor: negativeColor, Constants.ITEM_MANIFEST_TIME)
        opponentItemNode!.name = "opponentItem"
        opponentItemNode!.position = CGPoint(x: width / 2, y: height / 5)
        opponentItemNode!.zPosition = 1
        opponentItemNode!.addRotation()
        self.addChild(opponentItemNode!)

        if let timerList = timerList {
            timerList.forEach {
                $0.resetRemainingTime()
                $0.freezeTimer(forSeconds: moveTime)
            }
        }
        
        opponentItemTimer = TimeManager(maxTime: moveTime + item.activeTime, timerName: "opponentItemTimer", maxTimeIntervalForReduction: 0.1)
        opponentItemTimer!.delegate = self
        opponentItemTimer!.startTimer()
    }
    
    func pause() {
        opponentItemTimer?.stopTimer()
        opponentItemNode?.pause()
        (self.childNode(withName: "playerItem") as? ItemPanel)?.pause()
        (self.childNode(withName: "progressSpark") as? ItemPanel)?.pause()
        self.childNode(withName: "playerItem")?.isUserInteractionEnabled = false
    }
    
    func resume() {
        opponentItemTimer?.startTimer()
        opponentItemNode?.resume()
        (self.childNode(withName: "playerItem") as? ItemPanel)?.resume()
        (self.childNode(withName: "progressSpark") as? ItemPanel)?.resume()
        self.childNode(withName: "playerItem")?.isUserInteractionEnabled = true
    }
    
    func reset() {
        gameScore?.setText(to: "0")
        scoreMultiplicator?.setText(to: "x1.0")
        
        let tempDel = delegate
        delegate = nil
        playerItem = nil
        opponentItem?.deactivate?()
        opponentItemNode?.removeFromParent()
        opponentItemTimer?.stopTimer()
        opponentItemTimer = nil
        delegate = tempDel
    }
    
    func removeAllObjects() {
        delegate = nil
        gameScore?.removeFromParent()
        
        scoreMultiplicator?.removeFromParent()
        
        playerItem = nil
        opponentItem = nil
        opponentItemNode?.removeFromParent()
        opponentItemTimer?.stopTimer()
        opponentItemTimer = nil
        
        self.removeFromParent()
    }
}

extension OverlayScene : ItemPanelDelegate, TimeManagerDelegate {
    func clicked(name: String) {
        switch name {
            case "playerItem":
                guard let playerItemNode : ItemPanel = self.childNode(withName: "playerItem") as? ItemPanel else {return}
                
                playerItemNode.disappear(in: Constants.ITEM_DISAPPEAR_TIME)
                let when = DispatchTime.now() + Constants.ITEM_DISAPPEAR_TIME
                DispatchQueue.main.asyncAfter(deadline: when) {[weak self] in
                    guard let strongS = self else {return}
                    strongS.playerItem = nil
                }
                
                break
            
            default: break;
        }
    }
    
    func updatedRemainingTime(of name: String, to time: Double) {
        if name == "opponentItemTimer" {
            guard let item = opponentItem else {return}
            if time.shorten(to: 1) == opponentItemTimer!.currentMaxTime - appearTime {
                guard let opponentItemNode = opponentItemNode else {return}
                opponentItemNode.removeAllActions()
                let move = SKAction.move(to: CGPoint.init(x: opponentItemNode.frame.width * 0.4 / 1.5, y: height / 2), duration: Constants.ITEM_MOVE_TIME)
                let shrink = SKAction.scale(to: 0.4, duration: Constants.ITEM_MOVE_TIME)
                
                opponentItemNode.run(shrink)
                opponentItemNode.run(move)
            }
            
            if time.shorten(to: 1) == opponentItemTimer!.currentMaxTime - moveTime {
                overlayDelegate?.opponentItemShown(item)
                item.execute(item)
                guard let opponentItemNode = opponentItemNode else {return}
                opponentItemNode.removeAllActions()
                opponentItemNode.addTimer(with: item.activeTime)
            }
            
            if time.shorten(to: 1) <= 0 {
                item.deactivate?()
                opponentItemNode?.removeFromParent()
                opponentItem = nil
                opponentItemTimer?.stopTimer()
                opponentItemTimer = nil
            }
        }
    }
}
