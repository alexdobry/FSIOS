//
//  ViewController.swift
//  Card
//
//  Created by Alex on 25.04.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: outlets
    
    @IBOutlet var cardButtons: [CardView]!
    @IBOutlet weak var flipCountLabel: UILabel!
    
    // MARK: model
    
    var game: MatchingCardGame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = MatchingCardGame(numberOfCards: self.cardButtons.count)
        game?.delegate = self
    }
    
    // MARK: target-action
    
    @IBAction func cardButtonTapped(_ sender: CardView) {
        guard game != nil else { return }
        guard let index = cardButtons.index(of: sender) else { return }
        guard !sender.facedUp else { return }
        
        let result = game!.revealCard(at: index)
        
        print(result)
        
        switch result {
        case .pending(let card):
            sender.card = card

        case .match(let first, let second):
            sender.card = second
            
            let otherCard = cardButtonMatching(card: first)
            let matchedCards = [sender, otherCard]
            
            matchedCards.forEach { card in
                card.matched = true
                card.disable = true
            }
            
        case .noMatch(let first, let second):
            sender.card = second
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                let other = self.cardButtonMatching(card: first)
                
                sender.card = nil
                other.card = nil
            })
            
        case .gameOver(let cards):
            print(cards)
            
            cardButtons.forEach { card in card.disable = true }
        }
    }
    
    // MARK: view helpers
    
    private func cardButtonMatching(card: Card) -> CardView {
        return cardButtons.first(where: { $0.currentTitle == card.description })!
    }
}


// MARK: MatchingCardGameDelegate - sync ui with score
extension ViewController: MatchingCardGameDelegate {
    
    func matchingCardGameScoreDidChange(to score: Int) {
        flipCountLabel.text = "Score: \(score)"
    }
}

