//
//  Items.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 10.06.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import Foundation

enum GameMode : String {
    case single = "singlePlayer"
    case multi = "multiPlayer"
}

struct Item {
    
//MARK: Properties
    let name : String
    let imageName : String
    let description : String
    let gameType : String
    var execute : (GameViewController) -> Void
    
    
//MARK: Functions
    init(itemName: String, imageName: String, description: String, gameType: String, _ executeFunction: @escaping (GameViewController) -> Void ) {
        self.name = itemName
        self.imageName = imageName
        self.description = description
        self.gameType = gameType
        execute = executeFunction
    }
    

}

extension Dictionary {
    func randomItem() -> Value {
        let index: Int = Int(arc4random_uniform(UInt32(self.count)))
        return Array(self.values)[index]
    }
}

extension Array {
    func randomItem() -> Element {
        let index: Int = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

//MARK: Items and their functions
struct ItemManager {
    let items : [String:Item] = [
            //SUBMARK: SinglePlayerItem: sameDirection
            "sameDirection": Item(
            itemName: "sameDirection",
            imageName: "sameDirection.png",
            description: "The swipe-direction gets frozen. For 10 seconds the user only needs to swipe in one direction.",
            gameType: GameMode.single.rawValue)
            {
                weak var controller = $0
                let oldDirectionManager = $0.directionManager
                let newDirectionManager : DirectionManager
                
                if let currentDirection = oldDirectionManager.currentDirection {
                    newDirectionManager = SameDirectionManager(standardDirection: currentDirection)
                } else {
                    newDirectionManager = SameDirectionManager(standardDirection: Direction.randomDirection())
                }
                
                let when = DispatchTime.now() + 10
                $0.directionManager = newDirectionManager
                DispatchQueue.main.asyncAfter(deadline: when) {[weak controller] in
                    guard let weakController = controller else {return}
                    weakController.directionManager = oldDirectionManager
                }
            },
        
        //SUBMARK: MultiPlayerItem: reverseDirection
        "reverseDirection": Item(
            itemName: "reverseDirection",
            imageName: "reverseDirection.png",
            description: "The swipe-direction is reversed. For 10 seconds the user needs to swipe to the opposite direction of the one that is shown.",
            gameType: GameMode.multi.rawValue)
            {
                weak var controller = $0
                let oldDirectionManager = $0.directionManager
                let newDirectionManager : DirectionManager
                
                if let currentDirection = oldDirectionManager.currentDirection {
                    newDirectionManager = ReverseDirectionManager(currentDirection: currentDirection)
                } else {
                    newDirectionManager = ReverseDirectionManager(currentDirection: Direction.randomDirection())
                }
                
                let when = DispatchTime.now() + 10
                $0.directionManager = newDirectionManager
                DispatchQueue.main.asyncAfter(deadline: when) {[weak controller] in
                    guard let weakController = controller else {return}
                    weakController.directionManager = oldDirectionManager
                }
            },
        
        //SUBMARK: MultiPlayerItem: halfArrowTime
        "halfArrowTime": Item(
            itemName: "halfArrowTime",
            imageName: "halfArrowTime.png",
            description: "Reduce the time to performing a swipe. During this item the performing time is halved.",
            gameType: GameMode.multi.rawValue)
            {
                weak var controller = $0
                let oldTime = $0.arrowTimer.currentMaxTime
                let newTime = (oldTime / 2)
                
                $0.arrowTimer.stopTimer()
                $0.arrowTimer.currentMaxTime = newTime
                $0.arrowTimer.currentTimeIntervalForReduction = newTime
                $0.arrowTimer.resetRemainingTime()
                
                let when = DispatchTime.now() + 10 + ItemPanel.ITEM_SHOW_TIME
                DispatchQueue.main.asyncAfter(deadline: when) {[weak controller] in
                    guard let weakController = controller else {return}
                    weakController.arrowTimer.stopTimer()
                    weakController.arrowTimer.currentMaxTime = oldTime
                    weakController.arrowTimer.currentTimeIntervalForReduction = oldTime
                    weakController.arrowTimer.resetRemainingTime()
                }
            }
    ]
    
    
    //MARK: Other Functions
    func randomItem(for gameMode: GameMode) -> Item {
        return items.filter{$0.value.gameType == gameMode.rawValue}.randomItem().value
    }
    
    func activateItem(_ itemName: String, on controller: GameViewController, for gameMode: GameMode) {
        let itemTupel = items.filter{$0.key == itemName && $0.value.gameType == gameMode.rawValue}
        if itemTupel.count > 0 {
            itemTupel[0].value.execute(controller)
        }
    }
    
}
