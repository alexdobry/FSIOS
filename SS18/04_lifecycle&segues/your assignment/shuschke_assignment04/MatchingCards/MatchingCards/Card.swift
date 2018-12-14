//
//  Card.swift
//  MatchingCards
//
//  Created by Alex on 29.03.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Card {
    let suit: Suit
    let rank: Rank
    
    enum Suit: String {
        case spade = "♠️"
        case club = "♣️"
        case heart = "❤️"
        case diamond = "♦️"
        
        static let all = [spade, club, heart, diamond]
    }
    
    enum Rank: String {
        case two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", ten = "10"
        case J, Q, K, A
        
        static let all = [two, three, four, five, six, seven, eight, nine, ten, J, Q, K, A]
    }
}

extension Card: CustomStringConvertible, Equatable {
    var description: String {
        return "\(suit.rawValue)\(rank.rawValue)"
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.suit == rhs.suit && lhs.rank == rhs.rank
    }
}
