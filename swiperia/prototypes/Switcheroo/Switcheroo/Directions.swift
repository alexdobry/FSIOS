//
//  Directions.swift
//  Switcheroo
//
//  Created by Dennis Dubbert on 06.05.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import AudioToolbox
import UIKit

protocol DirectionManagerDelegate{
    func directionChanged(direction: String)
    func finishedDirections(score: Int)
    func checkSolution(text: String, count: Int, color: UIColor)
}

enum Directions: String {
    case up         = "↑"
    case right      = "→"
    case down       = "↓"
    case left       = "←"
    case upLeft     = "↖"
    case upRight    = "↗"
    case downLeft   = "↙"
    case downRight  = "↘"
    
    static let all = [up, right, down, left, upLeft, upRight, downLeft, downRight]
    
    static func randomDirection() -> Directions {
        let index = Int(arc4random_uniform(UInt32(all.count)))
        let direction = all[index]
        return direction
    }
}

extension Directions: Equatable {
    static func ==(lhs: Directions, rhs: Directions) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

struct DirectionManager{
    var delegate: DirectionManagerDelegate?
    //var directionList: [Direction]
    //let times: [Float]
    private var switchTimer: SwitchTimer
    private var counter: Int
    private var score: Int
    private var activeDirection: Direction?
    private var winstreak: Int {
        didSet{
            if 0 < winstreak && winstreak < 5{
                delegate?.checkSolution(text: "Nice", count: winstreak, color: UIColor.green)
            }else if 5 <= winstreak && winstreak < 10{
                delegate?.checkSolution(text: "Professional", count: winstreak, color: UIColor.blue)
            }else if 10 <= winstreak{
                delegate?.checkSolution(text: "Master", count: winstreak, color: UIColor.purple)
            }
        }
    }
    
    /*mutating func createDirections(){
        directionList = (0...times.count-1).map { createRandomDirection(time: times[$0])
        }
        activateNextDirection()
    }*/
    
    private func createRandomDirection() -> Direction{
        var time: Float = 0
        if counter < 10 {
            time += 1
        }
        if counter < 15 {
            time += 1
        }
        
        return Direction(time: time, direction: Directions.randomDirection())
    }
    
    mutating func checkDirectionInput(_ dir: Directions){
        // FIX: crappy atm
        guard activeDirection != nil else { return }
        
        //guard counter < directionList.count else {return}
        if dir == activeDirection!.direction{ //directionList[counter].direction{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            counter += 1
            score += 1
            winstreak += 1
            activateNextDirection()
        }else {
            delegate?.checkSolution(text: "Fail!", count: 0, color: UIColor.red)
            winstreak = 0
        }
    }
    
    mutating func activateNextDirection(){
        //if counter < directionList.count {
            activeDirection = createRandomDirection()
            switchTimer.addTime(activeDirection!.time) //directionList[counter].time)
            delegate?.directionChanged(direction: activeDirection!.direction.rawValue)//directionList[counter].direction.rawValue)
        /*}else{
            stopGame()
        }*/
     
    }
    
    func stopGame(){
        switchTimer.stopTimer()
        delegate?.finishedDirections(score: score)
    }
    
    mutating func reset(){
        switchTimer.reset()
        
        //createDirections()
        
        counter = 0
        score = 0
        winstreak = 0
        activateNextDirection()
    }
    
    init(timer: SwitchTimer, delegateTo: DirectionManagerDelegate){
        delegate = delegateTo
        switchTimer = timer
        counter = 0
        
        //times  = [5, 4, 3, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        //directionList = []
        score = 0
        winstreak = 0
    }
}

struct Direction{
    
    private(set) var time: Float
    private(set) var direction: Directions
    
    init(time: Float, direction: Directions) {
        self.time = time
        self.direction = direction
    }
}
