//
//  Deck.swift
//  MatchingCards
//
//  Created by Alex on 18.04.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Deck {
    private(set) var cards: [Card] = []
    
    var numberOfCards: Int { // read only
        return cards.count
    }
    
    init() {
        for suit in Card.Suit.all {
            for rank in Card.Rank.all {
                cards.append(Card(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func drawRandomCard() -> Card? {
        if cards.isEmpty {
            return nil
        } else {
            let index = arc4random_uniform(UInt32(cards.count))
            return cards.remove(at: Int(index))
        }
    }
}
