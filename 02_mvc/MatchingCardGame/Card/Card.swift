//
//  Card.swift
//  Card
//
//  Created by Alex on 02.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum Suit: String {
    case spade = "♠︎"
    case club = "♣︎"
    case heart = "♥︎"
    case diamond = "♦︎"
    
    static let all = [spade, club, heart, diamond]
}

enum Rank: String {
    case two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", ten = "10"
    case J, Q, K, A
    
    static let all = [J, Q, K, A] + [two, three, four, five, six, seven, eight, nine, ten]
}

struct Card {
    let suit: Suit
    let rank: Rank
}

extension Card: CustomStringConvertible {
    var description: String {
        return suit.rawValue.appending(rank.rawValue)
    }
}

struct Deck {
    var cards: [Card] = []
    
    init() {
        for suit in Suit.all {
            for rank in Rank.all {
                self.cards.append(Card(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func drawRandomCard() -> Card? {
        guard !cards.isEmpty else { return nil }
        
        let index = Int(arc4random_uniform(UInt32(cards.count)))
        return cards.remove(at: index)
    }
}
