//
//  ItemManager.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 15.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation

enum GameMode : String {
    case single = "singlePlayer"
    case multi = "multiPlayer"
}

struct Item {
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
    let execute : (GameViewController) -> Void
    
    ///
    init(itemName: String, imageName: String, description: String, gameType: String, activeTime: Double, _ executeFunction: @escaping (GameViewController) -> Void) {
        self.name = itemName
        self.imageName = imageName
        self.description = description
        self.gameType = gameType
        self.activeTime = activeTime
        self.execute = executeFunction
    }
}

struct ItemManager {
    let items:[String: Item] = [
        // MARK: SinglePlayerItem:  sameDirection
        "sameDirection": Item(
            itemName: "sameDirection",
            imageName: "sameDirection",
            description: "The swipe-direction is frozen. For 10 seconds the user only needs to swipe in one direction.",
            gameType: GameMode.single.rawValue,
            activeTime: 10) {
                weak var controller = $0
                let oldDirectionManager = $0.directionManager
                var newDirectionManager : DirectionManager
                if let currentDirection = oldDirectionManager.currentDirection {
                    newDirectionManager = SameDirectionManager(standardDirection: currentDirection)
                } else {
                    newDirectionManager = SameDirectionManager(standardDirection: Direction.randomDirection())
                }
                
                $0.directionManager = newDirectionManager
                let delay = 10 + Constants.ITEM_SHOW_TIME
                let when = DispatchTime.now() + delay
                DispatchQueue.main.asyncAfter(deadline: when) {[weak controller] in
                    guard let strongC = controller else {return}
                    strongC.directionManager = oldDirectionManager
                }
        },
        // MARK: MultiPlayerItem:   reverseDirection
        "reverseDirection": Item(
            itemName: "reverseDirection",
            imageName: "reverseDirection",
            description: "The swipe-direction is reversed. For 10 seconds the user needs to swipe to the opposite direction of the one that is shown.",
            gameType: GameMode.multi.rawValue,
            activeTime: 10) {
                weak var controller = $0
                let oldDirectionManager = $0.directionManager
                var newDirectionManager : DirectionManager
                
                if let currentDirection = oldDirectionManager.currentDirection {
                    newDirectionManager = ReverseDirectionManager(currentDirection: currentDirection)
                } else {
                    newDirectionManager = ReverseDirectionManager(currentDirection: Direction.randomDirection())
                }
                
                $0.directionManager = newDirectionManager
                let delay = 10 + Constants.ITEM_SHOW_TIME
                let when = DispatchTime.now() + delay
                DispatchQueue.main.asyncAfter(deadline: when) {[weak controller] in
                    guard let strongC = controller else {return}
                    strongC.directionManager = oldDirectionManager
                }
        },
        // MARK: MultiPlayerItem:   halfArrowTime
        "halfArrowTime": Item(
            itemName: "halfArrowTime",
            imageName: "halfArrowTime",
            description: "Reduces the time for a successfull swipe. For 10 seconds the users time to do a swipe is halved.",
            gameType: GameMode.multi.rawValue,
            activeTime: 10) {
                weak var controller = $0
                let oldTime = $0.arrowTimer.currentMaxTime
                let newTime = oldTime / 2
                
                $0.arrowTimer.stopTimer()
                $0.arrowTimer.currentMaxTime = newTime
                $0.arrowTimer.currentTimeIntervalForReduction = newTime
                $0.arrowTimer.resetRemainingTime()
                let delay = 10 + Constants.ITEM_SHOW_TIME
                let when = DispatchTime.now() + delay
                DispatchQueue.main.asyncAfter(deadline: when) {[weak controller] in
                    guard let strongC = controller else {return}
                    strongC.arrowTimer.stopTimer()
                    strongC.arrowTimer.currentMaxTime = oldTime
                    strongC.arrowTimer.currentTimeIntervalForReduction = oldTime
                    strongC.arrowTimer.resetRemainingTime()
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
            itemTupel[0].value.execute(controller)
        }
    }
}
