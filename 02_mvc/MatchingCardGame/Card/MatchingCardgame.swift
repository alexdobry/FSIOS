//
//  MatchingCardgame.swift
//  Card
//
//  Created by Alex on 02.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

extension Array {
    
    func groupBy<K : Hashable>(key: (Element) -> K) -> [K: [Element]] {
        var dict: [K: [Element]] = [:]
        
        forEach { elem in
            let k = key(elem)
            if case nil = dict[k]?.append(elem) { dict[k] = [elem] }
        }
        
        return dict
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.description == rhs.description
    }
}

protocol MatchingCardGameDelegate {
    func matchingCardGameScoreDidChange(to score: Int)
}

enum MatchingGameResult {
    case pending(Card)
    case match(Card, Card)
    case noMatch(Card, Card)
    case gameOver([Card])
}

struct MatchingCardGame {
    private var deck: Deck
    
    var delegate: MatchingCardGameDelegate?
    
    private var previousCard: Card?
    private var matchedCards: [Card] = []
    
    private var totalScore: Int = 0 {
        didSet {
            delegate?.matchingCardGameScoreDidChange(to: totalScore)
        }
    }
    
    init(numberOfCards: Int) {
        self.deck = Deck()
        
        let cards = (0..<numberOfCards).map { _ in deck.drawRandomCard()! }
        
        deck.cards = cards
    }
    
    mutating func revealCard(at index: Int) -> MatchingGameResult {
        guard isMatchPossible else { return .gameOver(pendingCards) }
        
        let card = deck.cards[index]
        
        if let previous = previousCard {
            if previousCard(previous, isMatchingWith: card) {
                self.previousCard = nil
                matchedCards = matchedCards + [previous, card]
                return .match(previous, card)
            } else {
                self.previousCard = nil
                return .noMatch(previous, card)
            }
        } else {
            self.previousCard = card
            return .pending(card)
        }
    }
    
    private mutating func previousCard(_ previous: Card, isMatchingWith other: Card) -> Bool {
        var matched = false
        var score = 0
        
        if previous.suit == other.suit {
            score += 5
            matched = true
        }
        
        if previous.rank == other.rank {
            score += 5 * 2
            matched = true
        }
        
        totalScore += score == 0 ? -3 : score
        
        
        return matched
    }
    
    var pendingCards: [Card] {
        return deck.cards.filter { card in
            !matchedCards.contains(card)
        }
    }
    
    var isMatchPossible: Bool {
        let pending = pendingCards
        
        let groupedByRank = pending.groupBy(key: { $0.rank }).contains(where: { $0.value.count >= 2 })
        let groupedBySuit = pending.groupBy(key: { $0.suit }).contains(where: { $0.value.count >= 2 })
        
        return groupedBySuit || groupedByRank
    }
}
