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
    
    private static let allDirections = [up, upRight, right, downRight, down, downLeft, left, upLeft]
    
    static func randomDirection() -> Direction {
        return allDirections[Int(arc4random_uniform(UInt32(allDirections.count)))]
    }
}

extension Direction: Equatable {
    static func == (lhs: Direction, rhs: Direction) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}


