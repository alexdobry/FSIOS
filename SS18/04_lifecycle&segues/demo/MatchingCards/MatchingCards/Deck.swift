//
//  Deck.swift
//  MatchingCards
//
//  Created by Alex on 04.04.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Deck {
    private(set) var cards: [Card] = []
    
    init() {
        for suit in Card.Suit.all {
            for rank in Card.Rank.all {
                cards.append(Card(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func drawRandomCard() -> Card? {
        guard !cards.isEmpty else { return nil }
        
        let index = arc4random_uniform(UInt32(cards.count))
        return cards.remove(at: Int(index))
    }
}
