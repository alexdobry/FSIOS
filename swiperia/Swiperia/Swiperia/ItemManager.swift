//
//  ItemManager.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 15.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

enum GameMode : String {
    case single = "singlePlayer"
    case multi = "multiPlayer"
    
    static let allGameModes = [single, multi]
    
    static func random() -> GameMode {
        return allGameModes[Int(arc4random_uniform(UInt32(allGameModes.count)))]
    }
    
    static func == (lhs: GameMode , rhs: GameMode) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

class Item {
    ///
    var isActive = false
    ///
    let name : String
    ///
    let imageName : String
    ///
    let description : String
    ///
    let gameType : String
    ///
    let activeTime : Double
    ///
    let execute : (Item) -> Void
    ///
    var deactivate : (() -> Void)?
    ///
    weak var controller : GameViewController?
    ///
    init(itemName: String, imageName: String, description: String, gameType: String, activeTime: Double, _ executeFunction: @escaping (Item) -> Void) {
        name = itemName
        self.imageName = imageName
        self.description = description
        self.gameType = gameType
        self.activeTime = activeTime
        execute = executeFunction
    }
}

class ItemManager {
    let items:[String: Item] = [
        // MARK: SinglePlayerItem:  sameDirection
        "sameDirection": Item(
            itemName: "sameDirection",
            imageName: "sameDirection",
            description: "The swipe-direction is frozen. For 10 seconds the user only needs to swipe in one direction.",
            gameType: GameMode.single.rawValue,
            activeTime: 10) {
                var con = $0.controller
                guard let controller = con else {return}
                var oldDirectionManager = controller.directionManager
                let rotationSpeed = controller.geometryNode.rotatingSpeed
                var newDirectionManager : DirectionManager
                controller.gameScore.itemChargable = false
                if let currentDirection = oldDirectionManager.currentDirection {
                    newDirectionManager = SameDirectionManager(standardDirection: currentDirection)
                } else {
                    newDirectionManager = SameDirectionManager(standardDirection: Direction.random())
                }
                
                controller.directionManager = newDirectionManager
                controller.geometryNode.rotatingSpeed = rotationSpeed / 2
                
                $0.isActive = true
                var item = $0

                $0.deactivate = {[weak controller, weak item] in
                    guard let strongC = controller, let strongI = item else {return}
                    if strongI.isActive {
                        strongI.isActive = false
                        oldDirectionManager.currentDirection = strongC.directionManager.currentDirection
                        strongC.directionManager = oldDirectionManager
                        strongC.geometryNode.rotatingSpeed = rotationSpeed
                        strongC.gameScore.itemChargable = true
                    }
                }
            },
        "freezeTime": Item(
            itemName: "freezeTime",
            imageName: "freezeTime",
            description: "The time is frozen. The user has the possibility to take a breath for 10 seconds (he will still be punished if a swipe was incorrect).",
            gameType: GameMode.single.rawValue,
            activeTime: 10) {
                var con = $0.controller
                guard let controller = con else {return}
                controller.gameTimer.stopTimer()
                controller.arrowTimer.stopTimer()
                
                $0.isActive = true
                var item = $0
                
                $0.deactivate = {[weak controller, weak item] in
                    guard let strongC = controller, let strongI = item else {return}
                    if strongI.isActive {
                        strongI.isActive = false
                        strongC.gameTimer.startTimer()
                        strongC.arrowTimer.startTimer()
                    }
                }
            },
        // MARK: MultiPlayerItem:   reverseDirection
        "reverseDirection": Item(
            itemName: "reverseDirection",
            imageName: "reverseDirection",
            description: "The swipe-direction is reversed. For 10 seconds the user needs to swipe to the opposite direction of the one that is shown.",
            gameType: GameMode.multi.rawValue,
            activeTime: 10) {
                var con = $0.controller
                guard let controller = con else {return}
                var oldDirectionManager = controller.directionManager
                var newDirectionManager : DirectionManager
                
                if let currentDirection = oldDirectionManager.currentDirection {
                    newDirectionManager = ReverseDirectionManager(currentDirection: currentDirection)
                } else {
                    newDirectionManager = ReverseDirectionManager(currentDirection: Direction.random())
                }
                
                controller.directionManager = newDirectionManager

                $0.isActive = true
                var item = $0
                
                $0.deactivate = {[weak controller, weak item] in
                    guard let strongC = controller, let strongI = item else {return}
                    if strongI.isActive {
                        strongI.isActive = false
                        oldDirectionManager.currentDirection = strongC.directionManager.currentDirection
                        strongC.directionManager = oldDirectionManager
                    }
                }
            },
        // MARK: MultiPlayerItem:   halfArrowTime
        "halfArrowTime": Item(
            itemName: "halfArrowTime",
            imageName: "halfArrowTime",
            description: "Reduces the time for a successfull swipe. For 10 seconds the users time to do a swipe is halved.",
            gameType: GameMode.multi.rawValue,
            activeTime: 10) {
                var con = $0.controller
                guard let controller = con else {return}
                let oldTime = controller.arrowTimer.currentMaxTime
                let newTime = oldTime / 2
                
                controller.arrowTimer.currentMaxTime = newTime
                controller.arrowTimer.currentTimeIntervalForReduction = newTime
                controller.arrowTimer.resetRemainingTime()

                $0.isActive = true
                var item = $0
                
                $0.deactivate = {[weak controller, weak item] in
                    guard let strongC = controller, let strongI = item else {return}
                    if strongI.isActive {
                        strongI.isActive = false
                        strongC.arrowTimer.currentMaxTime = oldTime
                        strongC.arrowTimer.currentTimeIntervalForReduction = oldTime
                        strongC.arrowTimer.resetRemainingTime()
                    }
                }
        },
        // MARK: MultiPlayerItem:   earthquake
        "earthquake": Item(
            itemName: "earthquake",
            imageName: "earthquake",
            description: "An earthquake breaks out. For 10 seconds the arrows are shaking. For that time the time-progress will disappear.",
            gameType: GameMode.multi.rawValue,
            activeTime: 10) {
                var con = $0.controller
                guard let controller = con else {return}
                
                let camera = controller.gameScene.rootNode.childNode(withName: "cameraNode", recursively: false)
                let cameraPosition = camera?.position
                let progressOpacity = controller.progress.opacity
                let sparkAlpha = controller.overlay.childNode(withName: "progressSpark")?.alpha

                if camera != nil && cameraPosition != nil {
                    let mF : Float = 1
                    let moveLeft = SCNAction.move(by: SCNVector3Make(-mF, 0, 0), duration: 0.05)
                    let moveRight = SCNAction.move(by: SCNVector3Make(mF * 2, 0, 0), duration: 0.05)
                    let moveUp = SCNAction.move(by: SCNVector3Make(0, mF, 0), duration: 0.05)
                    let moveDown = SCNAction.move(by: SCNVector3Make(0, -2*mF, 0), duration: 0.05)
                    let combined = SCNAction.repeatForever(SCNAction.sequence([moveLeft, moveRight, moveLeft, moveUp, moveDown, moveUp]))
                    
                    camera!.runAction(combined, forKey: "earthquake")
                    controller.progress.opacity = 0
                    controller.overlay.childNode(withName: "progressSpark")?.alpha = 0
                }
                
                $0.isActive = true
                var item = $0
                
                $0.deactivate = {[weak controller, weak camera, weak item] in
                    guard let strongCA = camera, let strongCP = cameraPosition, let strongC = controller, let strongI = item else {return}
                    if strongI.isActive {
                        strongI.isActive = false
                        strongCA.removeAction(forKey: "earthquake")
                        strongCA.runAction(SCNAction.move(to: cameraPosition!, duration: 0.1))
                        strongC.progress.opacity = progressOpacity
                        if sparkAlpha != nil  {strongC.overlay.childNode(withName: "progressSpark")?.alpha = sparkAlpha!}
                    }
                }
        },
        // MARK: MultiPlayerItem:   blizzard
        "blizzard": Item(
            itemName: "blizzard",
            imageName: "blizzard",
            description: "A blizzard breaks out. For 10 seconds the users vision is impaired.",
            gameType: GameMode.multi.rawValue,
            activeTime: 10) {
                var con = $0.controller
                guard let controller = con else {return}
                
                let border = SnowLayer(frame: controller.view.frame)
                
                controller.gameView.layer.addSublayer(border)
                
                $0.isActive = true
                var item = $0
                
                $0.deactivate = {[weak border, weak item] in
                    guard let strongB = border, let strongI = item else {return}
                    if strongI.isActive {
                        strongI.isActive = false
                        strongB.removeFromSuperlayer()
                    }
                }
        },
        // MARK: MultiPlayerItem:   turnAround
        "turnAround": Item(
            itemName: "turnAround",
            imageName: "turnAround",
            description: "For 10 seconds the game has to be played upside down.",
            gameType: GameMode.multi.rawValue,
            activeTime: 10) {
                var con = $0.controller
                guard let controller = con else {return}
                controller.subView.transform = CGAffineTransform(rotationAngle: CGFloat(180 / 180.0 * .pi))
                
                var oldDirectionManager = controller.directionManager
                var newDirectionManager : DirectionManager
                
                if let currentDirection = oldDirectionManager.currentDirection {
                    newDirectionManager = ReverseDirectionManager(currentDirection: currentDirection)
                } else {
                    newDirectionManager = ReverseDirectionManager(currentDirection: Direction.random())
                }
                
                controller.directionManager = newDirectionManager
                
                $0.isActive = true
                var item = $0
                
                $0.deactivate = {[weak controller, weak item] in
                    guard let strongC = controller, let strongI = item else {return}
                    if strongI.isActive {
                        strongI.isActive = false
                        strongC.subView.transform = CGAffineTransform(rotationAngle: CGFloat(0 / 180.0 * .pi))
                        oldDirectionManager.currentDirection = strongC.directionManager.currentDirection
                        strongC.directionManager = oldDirectionManager
                    }
                }
            }
    
    ]
    
    ///
    func randomItem (for gameMode: GameMode) -> Item {
        return items.filter {$0.value.gameType == gameMode.rawValue}.randomItem().value
    }
    
    func getSpecificItem(_ itemName: String, for gameMode: GameMode) -> Item {
        return items.filter {$0.key == itemName && $0.value.gameType == gameMode.rawValue}[0].value
    }
    
    ///
    func activateItem (_ itemName: String, on controller: GameViewController, for gameMode: GameMode) {
        let itemTupel = items.filter {$0.key == itemName && $0.value.gameType == gameMode.rawValue}
        if itemTupel.count > 0 {
            itemTupel[0].value.execute(itemTupel[0].value)
        }
    }
}
