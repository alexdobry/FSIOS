//
//  ViewController.swift
//  MatchingCards
//
//  Created by Alex on 18.04.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MatchingCardGameDelegate {
    
    // MARK: - View
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    // MARK: - Model
    lazy var game = MatchingCardGame(numberOfCards: cardButtons.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
    }

    @IBAction func flipCard(_ sender: UIButton) {
        let index = cardButtons.index(of: sender)!
        
        let result = game.revealCard(at: index)
        
        print(result)
        
        switch result {
        case .pending(let card):
            // erste karte aufdecken
            sender.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            sender.setTitle(card.description, for: .normal)
            
        case .match(let first, let second):
            //  zweite karte aufdecken
            sender.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            sender.setTitle(second.description, for: .normal)
            
            // beide karten als match markieren
            sender.isUserInteractionEnabled = false
            sender.alpha = 0.5
            
            let firstSender = cardButtonMatching(card: first)
            firstSender.isUserInteractionEnabled = false
            firstSender.alpha = 0.5
            
        case .noMatch(let first, let second):
            // zweite karte aufdecken
            sender.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            sender.setTitle(second.description, for: .normal)
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
                // beide karten zudecken
                sender.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
                sender.setTitle("", for: .normal)
                
                let firstSender = self.cardButtonMatching(card: first)
                firstSender.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
                firstSender.setTitle("", for: .normal)
            })
            
        case .gameOver:
            for button in cardButtons {
                button.isUserInteractionEnabled = false
                button.alpha = 0.5
            }
        }
    }
    
    private func cardButtonMatching(card: Card) -> UIButton {
        return cardButtons.first(where: { cardButton in cardButton.currentTitle == card.description })!
    }
    
    func matchingCardGameScoreDidChange(to score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
}

