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
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var flipCountLabel: UILabel!
    
    // MARK: model
    
    var game: MatchingCardGame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = MatchingCardGame(numberOfCards: self.cardButtons.count)
        game?.delegate = self
    }
    
    // MARK: target-action
    
    @IBAction func cardButtonTapped(_ sender: UIButton) {
        guard game != nil else { return }
        guard let index = cardButtons.index(of: sender) else { return }
        guard !facedUp(sender) else { return }
        
        let result = game!.revealCard(at: index)
        
        print(result)
        
        switch result {
        case .pending(let card):
            flip(sender, withCard: card)

        case .match(let first, let second):
            flip(sender, withCard: second)
            
            let otherCard = cardButtonMatching(card: first)
            let matchedCards = [sender, otherCard]
            
            highlight(matchedCards)
            disable(matchedCards)
            
        case .noMatch(let first, let second):
            flip(sender, withCard: second)
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                let other = self.cardButtonMatching(card: first)
                
                self.flip(other, withCard: first)
                self.flip(sender, withCard: second)
            })
            
        case .gameOver(let cards):
            print(cards)
            
            disable(cardButtons)
        }
    }
    
    // MARK: view helpers
    
    private func cardButtonMatching(card: Card) -> UIButton {
        return cardButtons.first(where: { $0.currentTitle == card.description })!
    }
    
    private func flip(_ sender: UIButton, withCard card: Card) {
        if sender.currentTitle != nil { // front
            sender.setBackgroundImage(#imageLiteral(resourceName: "back"), for: .normal)
            sender.backgroundColor = nil
            sender.setTitle(nil, for: .normal)
        } else {
            sender.setBackgroundImage(nil, for: .normal)
            sender.backgroundColor = .lightGray
            sender.setTitle(card.description, for: .normal)
        }
    }
    
    private func highlight(_ cardButtons: [UIButton]) {
        cardButtons.forEach { button in
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    private func facedUp(_ button: UIButton) -> Bool {
        return button.currentTitle != nil
    }
    
    private func disable(_ buttons: [UIButton]) {
        buttons.forEach { button in
            button.isUserInteractionEnabled = false
            button.alpha = 0.5
        }
    }
}


// MARK: MatchingCardGameDelegate - sync ui with score
extension ViewController: MatchingCardGameDelegate {
    
    func matchingCardGameScoreDidChange(to score: Int) {
        flipCountLabel.text = "Score: \(score)"
    }
}

