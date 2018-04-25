//
//  MatchingCardGame.swift
//  MatchingCards
//
//  Created by Alex on 18.04.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

protocol MatchingCardGameDelegate {
    func matchingCardGameScoreDidChange(to score: Int)
    func matchingCardGameDidEnd(with cards: [Card])
}

enum MatchingGameResult {
    case pending(with: Card)
    case match(first: Card, second: Card)
    case noMatch(first: Card, second: Card)
    case alreadySelected(Card)
}

class MatchingCardGame {
    private var cards: [Card] = []// 'numberOfCards' cards
    
    private var previousCard: Card?
    private var matchedCards: [Card]
    
    var delegate: MatchingCardGameDelegate?
    
    var score: Int = 0 {
        didSet {
            delegate?.matchingCardGameScoreDidChange(to: score)
        }
    }
    
    var pendingCards: [Card] {
        return cards.filter { card in
            !matchedCards.contains(card)
        }
    }
    
    private var isMatchingPossible: Bool {
        let p = pendingCards
        
        let ranks = Dictionary(grouping: p, by: { $0.rank }).contains(where: { $0.value.count >= 2 })
        let suits = Dictionary(grouping: p, by: { $0.suit }).contains(where: { $0.value.count >= 2 })
        
        return ranks || suits
    }
    
    init(numberOfCards: Int) {
        var deck: Deck = Deck() // 36 cards
        
        if numberOfCards >= deck.cards.count {
            fatalError("numberOfCards must be lower than \(deck.cards.count)")
        } else {
            self.matchedCards = []
            for _ in (0..<numberOfCards) {
                let card = deck.drawRandomCard()!
                cards.append(card)
            }
        }
    }
    
    func revealCard(at index: Int) -> MatchingGameResult {
        let result: MatchingGameResult
        
        switch cards[index] {
        case let sameCard where sameCard == previousCard:
            result = .alreadySelected(sameCard)
            
        case let matchableCard where previousCard != nil:
            let previous = previousCard!
            let (match, score) = previousCard(previous, isMatchingWith: matchableCard)
            
            self.previousCard = nil
            self.score += score
            
            if match {
                matchedCards.append(contentsOf: [previous, matchableCard])
                result = .match(first: previous, second: matchableCard)
            } else {
                result = .noMatch(first: previous, second: matchableCard)
            }
            
        case let pendingCard where previousCard == nil:
            self.previousCard = pendingCard
            result = .pending(with: pendingCard)
        default:
            fatalError("can't happen")
        }
        
        if !isMatchingPossible {
            delegate?.matchingCardGameDidEnd(with: pendingCards)
        }
        
        return result
    }
    
    private func previousCard(_ previousCard: Card, isMatchingWith other: Card) -> (match: Bool, score: Int) {
        var score = 0
        
        if previousCard.suit == other.suit {
            score += 5
        }
        
        if previousCard.rank == other.rank {
            score += 5 * 2
        }
        
        return (score != 0, score == 0 ? -3 : score)
    }
}
