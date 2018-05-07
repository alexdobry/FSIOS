//
//  MatchingCardGame.swift
//  MatchingCards
//
//  Created by Alex on 28.03.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum MatchingGameResult {
    case pending(Card)
    case match(first :Card, second: Card)
    case noMatch(first: Card, second: Card)
    case alreadySelected(Card)
}

protocol MatchingCardGameDelegate {
    func matchingCardGameScoreDidChange(to score: Int)
    func matchingCardGameDidEnd(with cards: [Card])
}

final class MatchingCardGame {
    private(set) var cards: [Card]
    
    private var previousCard: Card?
    private var matched: [Card]
    
    private var pendingCards: [Card] {
        return cards.filter { card in
            !matched.contains(card)
        }
    }
    
    private var isMatchingPossible: Bool {
        let p = pendingCards
        
        let ranks = Dictionary(grouping: p, by: { $0.rank }).contains(where: { $0.value.count >= 2 })
        let suits = Dictionary(grouping: p, by: { $0.suit }).contains(where: { $0.value.count >= 2 })
        
        return ranks || suits
    }
    
    var delegate: MatchingCardGameDelegate?
    
    var scoreIncrease = 5
    var scoreDecrease = 3
    
    private var score: Int = 0 {
        didSet {
            delegate?.matchingCardGameScoreDidChange(to: score)
        }
    }
    
    init(requiredCards: Int) {
        var deck = Deck()
        
        if requiredCards <= deck.cards.count {
            self.cards = (0..<requiredCards).flatMap { _ in deck.drawRandomCard() }
            self.matched = []
        } else {
            fatalError("not enough cards in deck")
        }
    }
    
    func flipCard(at index: Int) -> MatchingGameResult {
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
                matched.append(contentsOf: [previous, matchableCard])
                result = .match(first: previous, second: matchableCard)
            } else {
                result = .noMatch(first: previous, second: matchableCard)
            }
            
        case let pendingCard where previousCard == nil:
            self.previousCard = pendingCard
            result = .pending(pendingCard)
        default:
            fatalError("can't happen")
        }
        
        if !isMatchingPossible {
            delegate?.matchingCardGameDidEnd(with: pendingCards)
        }
        
        return result
    }
    
    private func previousCard(_ previous: Card, isMatchingWith other: Card) -> (match: Bool, score: Int) {
        var score = 0
        
        if previous.suit == other.suit {
            score += scoreIncrease
        }
        
        if previous.rank == other.rank {
            score += scoreIncrease * 2
        }
        
        return (score != 0, score == 0 ? -scoreDecrease : score)
    }
}
