//
//  GameScoreManager.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 09.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation

protocol GameScoreManagerDelegate: class {
    func scoreDidChange(to score: Double)
    func comboLevelDidChange(to level: Int)
    func itemProgressDidChange(to progress: Double)
    func itemProgressDidFinish()
}

class GameScoreManager {    
    ///
    private var score : Double = 0 {
        didSet {
            delegate?.scoreDidChange(to: score)
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
            for index in 0...comboLevel-1 {
                multiplicator *= Constants.MULTIPLICATOR_STEPS[index]
            }
        }
        return multiplicator
    }
    
    ///
    var comboCount : Int = 0 {
        didSet {
            if comboCount == currentAmountForLevelChange {
                comboCount = 0

                if comboLevel < Constants.MULTIPLICATOR_STEPS.count {comboLevel += 1}
            }
        }
    }
    
    ///
    private var comboLevel : Int = 0 {
        didSet {
            delegate?.comboLevelDidChange(to: comboLevel)
        }
    }
    
    ///
    private let standardAmountForLevelChange : Int
    
    ///
    private var currentAmountForLevelChange : Int {
        return Int(Double(standardAmountForLevelChange) * pow(Constants.LEVEL_CHANGE_MULTIPLICATOR, Double(comboLevel)))
    }

    ///
    private var itemProgress : Double = 0 {
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
    let itemProgressFinished : Double
    
    ///
    var itemChargable : Bool = true
    
    ///
    weak var delegate: GameScoreManagerDelegate?
    
    
    // MARK: Functions
    
    ///
    func scored(successfully success: Bool) {
        if success {
            comboCount += 1
            score += currentIncrement
            if itemChargable {itemProgress += 1}
        } else {
            comboCount = 0
            comboLevel = 0
        }
    }
    
    func reset() {
        let tempDel = delegate
        delegate = nil
        itemChargable = true
        itemProgress = 0
        comboLevel = 0
        comboCount = 0
        score = 0
        delegate = tempDel
    }
    
    init(standardScoreIncreaseAmount scoreInc: Double, standardAmountForLevelChange levelInc: Int, itemProgressFinished itemFinished: Double) {
        standardScoreIncreaseAmount = scoreInc
        standardAmountForLevelChange = levelInc
        itemProgressFinished = itemFinished
    }
}

