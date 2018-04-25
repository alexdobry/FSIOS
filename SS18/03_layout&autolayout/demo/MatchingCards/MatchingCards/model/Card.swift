//
//  Card.swift
//  MatchingCards
//
//  Created by Alex on 18.04.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Card: CustomStringConvertible, Equatable {
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }
    
    let suit: Suit
    let rank: Rank
    
    enum Suit: String {
        case heart = "❤️"
        case spade = "♠️"
        case diamond = "♦️"
        case club = "♣️"
        
        static let all: [Suit] = [heart, spade, diamond, club]
    }
    
    enum Rank: String {
        case two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", ten = "10"
        case J, Q, K, A
        
        static let all: [Rank] = [two, three, four, five, six, seven, eight, nine, ten, J, Q, K, A]
    }
    
    var description: String {
        return "\(rank.rawValue)\(suit.rawValue)"
    }
}
