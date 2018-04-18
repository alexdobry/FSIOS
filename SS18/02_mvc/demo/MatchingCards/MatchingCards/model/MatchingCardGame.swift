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
}

enum MatchingGameResult {
    case pending(with: Card)
    case match(first: Card, second: Card)
    case noMatch(first: Card, second: Card)
    case gameOver(with: [Card])
    // case alreadySelected(card: Card)
}

class MatchingCardGame {
    private var cards: [Card] = []// 'numberOfCards' cards
    
    private var previousCard: Card?
    private var matchedCards: [Card] = []
    
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
            for _ in (0..<numberOfCards) {
                let card = deck.drawRandomCard()!
                cards.append(card)
            }
        }
    }
    
    func revealCard(at index: Int) -> MatchingGameResult {
        guard isMatchingPossible else { return .gameOver(with: pendingCards) }
        
        let currentCard = cards[index]
        
        if let previous = previousCard {
            let (match, score) = previousCard(previous, isMatchingWith: currentCard)
            
            self.score += score
            self.previousCard = nil
            
            if match {
                matchedCards.append(previous)
                matchedCards.append(currentCard)
                
                return .match(first: previous, second: currentCard)
            } else {
                return .noMatch(first: previous, second: currentCard)
            }
        } else {
            previousCard = currentCard
            return .pending(with: currentCard)
        }
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
