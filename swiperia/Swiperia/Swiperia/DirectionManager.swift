//
//  Directions.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 10.06.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
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
    
    static func randomDirection() -> Direction {
        return allDirections[Int(arc4random_uniform(UInt32(allDirections.count)))]
    }
}

extension Direction: Equatable {
    static func == (lhs: Direction, rhs: Direction) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}


/// Direction Manager Protocol
protocol DirectionManager {
    var currentDirection: Direction? {get set}
    mutating func generateDirection()->Direction
    func compareCurrentDirection(with input: Direction) -> Bool
    mutating func reset()
}


/// Extension DirectionManager for standard implementation
extension DirectionManager {
    
    /// Generates a random direction
    ///
    /// - Returns: Direction (random)
    mutating func generateDirection () -> Direction {
        currentDirection = Direction.randomDirection()
        return currentDirection!
    }
    
    
    /// Compares the input direction with the lastly generated one
    ///
    /// - Parameter input: Direction
    /// - Returns: True if the directions match, false if they don't
    func compareCurrentDirection(with input: Direction) -> Bool {
        guard currentDirection != nil else {return false}
        return currentDirection == input
    }
    
    
    /// Resets the DirectionManager
    mutating func reset(){
        currentDirection = nil
    }
}


struct StandardDirectionManager : DirectionManager{
    var currentDirection: Direction?
}

//------------------: Item-Directions

struct SameDirectionManager : DirectionManager {
    var currentDirection: Direction?
    
    
    /// Always returns the direction supplied in the init-method
    ///
    /// - Returns: Direction
    mutating func generateDirection() -> Direction {
        return currentDirection!
    }
    
    /// Initializer
    ///
    /// - Parameter standardDirection: Standard direction for every output
    init(standardDirection : Direction) {
        currentDirection = standardDirection
    }
}

struct ReverseDirectionManager : DirectionManager {
    var currentDirection: Direction?
    
    /// Initializer
    ///
    /// - Parameter currentDirection: Current direction for every output
    init(currentDirection : Direction) {
        self.currentDirection = currentDirection
    }
    
    /// Compares the input direction with the lastly generated one
    ///
    /// - Parameter input: Direction
    /// - Returns: True if the input is the opposite, false if it's not
    func compareCurrentDirection(with input: Direction) -> Bool {
        guard currentDirection != nil else {return false}
        return Direction.allDirections[(Direction.allDirections.index(of: currentDirection!)! + 4) % 8] == input
    }
}
