//
//  GameScoreManager.swift
//  Swiperia
//
//  Created by Edgar Gellert on 09.08.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import Foundation

protocol GameScoreManagerDelegate : class {
    func scoreDidChange(to score : Double)
    func comboLevelDidChange(to level : Int)
    func itemProgressDidChange(to progress : Int)
    func itemProgressDidFinish()
}

class GameScoreManager {
    
//MARK: Properties
    
    ///
    static let LEVEL_CHANGE_MULTIPLICATOR : Double = 1.5
    
    ///
    static let MULTIPLICATOR_STEPS = [1.1, 1.2, 1.3, 1.5, 1.8, 2.3]
    
    ///
    private var score : Double = 0 {
        didSet {
            delegate?.scoreDidChange(to: score)
        }
    }
    
    ///
    private var comboCount : Int = 0 {
        didSet {
            if comboCount == currentAmountForLevelChange {
                comboCount = 0
                
                if comboLevel < GameScoreManager.MULTIPLICATOR_STEPS.count { comboLevel += 1 }
            }
        }
    }
    
    ///
    var comboLevel : Int = 0 {
        didSet {
            delegate?.comboLevelDidChange(to : comboLevel)
        }
    }
    
    ///
    private let standardScoreIncreaseAmount : Double
    
    ///
    private var currentIncrement : Double {
        return standardScoreIncreaseAmount * currentMultiplicator
    }
    
    
    ///
    var currentMultiplicator : Double {
        var multiplicator = 1.0
        if comboLevel > 0 {
            for index in 0...comboLevel - 1 {
                multiplicator *= GameScoreManager.MULTIPLICATOR_STEPS[index]
            }
        }
        return multiplicator
    }
    
    ///
    private let standardAmountForLevelChange : Int
    
    ///
    private var currentAmountForLevelChange : Int {
        return standardAmountForLevelChange * Int(pow(GameScoreManager.LEVEL_CHANGE_MULTIPLICATOR, Double(comboLevel)).rounded())
    }
    
    ///
    var itemProgress : Int = 0 {
        didSet {
            if itemProgress == itemProgressFinished {
                delegate?.itemProgressDidFinish()
                itemChargable = false
                itemProgress = 0
            } else {
                delegate?.itemProgressDidChange(to: itemProgress)
            }
        }
    }
    
    ///
    let itemProgressFinished : Int
    
    ///
    var itemChargable : Bool = true
    
    ///
    weak var delegate : GameScoreManagerDelegate?
    
    
//MARK: Functions
    
    ///
    func scored(successfully success : Bool) {
        if success {
            comboCount += 1
            score += currentIncrement
            itemProgress += 1
        } else {
            comboCount = 0
            comboLevel = 0
        }
    }
    
    ///
    init(standardScoreIncreaseAmount scoreInc : Double, standardAmountForLevelChange levelInc : Int, itemProgressFinished itemFinished : Int) {
        standardScoreIncreaseAmount = scoreInc
        standardAmountForLevelChange = levelInc
        itemProgressFinished = itemFinished
    }
}
