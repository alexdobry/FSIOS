//
//  Directions.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 27.05.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation

enum Direction: String {
    case up         = "↑"
    case upRight    = "↗"
    case right      = "→"
    case downRight  = "↘"
    case down       = "↓"
    case downLeft   = "↙"
    case left       = "←"
    case upLeft     = "↖"
    
    static let allDirections = [up, upRight, right, downRight, down, downLeft, left, upLeft]
    
    static func random() -> Direction {
        return allDirections[Int(arc4random_uniform(UInt32(allDirections.count)))]
    }
}

extension Direction: Equatable {
    static func == (lhs: Direction, rhs: Direction) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

protocol DirectionManager {
    var currentDirection: Direction? {get set}
    mutating func generateDirection() -> Direction
    func compareCurrentDirection(with input: Direction) -> Bool
    mutating func reset()
}

extension DirectionManager {
    mutating func generateDirection() -> Direction {
        currentDirection = Direction.random()
        return currentDirection!
    }
    
    func compareCurrentDirection(with input: Direction) -> Bool {
        guard currentDirection != nil else {return false}
        return currentDirection == input
    }
    
    mutating func reset() {
        currentDirection = nil
    }
}

struct StandardDirectionManager : DirectionManager {
    var currentDirection: Direction?
}

struct SameDirectionManager : DirectionManager {
    var currentDirection: Direction?
    
    mutating func generateDirection() -> Direction {
        return currentDirection!
    }
    
    init(standardDirection: Direction) {
        self.currentDirection = standardDirection
    }
}

struct ReverseDirectionManager : DirectionManager {
    var currentDirection: Direction?
    
    func compareCurrentDirection(with input: Direction) -> Bool {
        guard currentDirection != nil else {return false}
        
        return Direction.allDirections[(Direction.allDirections.index(of: currentDirection!)! + 4) % 8] == input
    }
    
    init(currentDirection: Direction) {
        self.currentDirection = currentDirection
    }
}
