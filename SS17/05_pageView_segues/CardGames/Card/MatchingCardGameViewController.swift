//
//  MatchingCardGameViewController.swift
//  Card
//
//  Created by Alex on 25.04.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MatchingCardGameViewController: UIViewController {
    
    // MARK: outlets
    
    @IBOutlet var cardButtons: [CardView]!
    @IBOutlet var landscapeCardButtons: [CardView]!
    @IBOutlet var portraitCardButtons: [CardView]!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    private var allCardButtons: [CardView] {
        let sizeClassDependentCardViews: [CardView] = {
            switch UIScreen.main.traitCollection.verticalSizeClass {
            case .compact:
                return landscapeCardButtons
            case .regular:
                return portraitCardButtons
            case .unspecified:
                return []
            }
        }()
        
        return cardButtons + sizeClassDependentCardViews
    }
    
    // MARK: model
    
    var game: MatchingCardGame?
    
    // MARK: viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = MatchingCardGame(numberOfCards: self.allCardButtons.count)
        game?.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        zip(landscapeCardButtons, portraitCardButtons).forEach { (land, port) in
            if size.height > size.width {
                // portrait
                land --> port
            } else {
                // landscape
                port --> land
            }
        }
    }
    
    // MARK: target-action
    
    @IBAction func cardButtonTapped(_ sender: CardView) {
        guard game != nil else { return }
        guard let index = allCardButtons.index(of: sender) else { return }
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
                card.disabled = true
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
            
            allCardButtons.forEach { card in card.disabled = true }
        }
    }
    
    // MARK: view helpers
    
    private func cardButtonMatching(card: Card) -> CardView {
        return allCardButtons.first(where: { $0.currentTitle == card.description })!
    }
}


// MARK: MatchingCardGameDelegate - sync ui with score
extension MatchingCardGameViewController: MatchingCardGameDelegate {
    
    func matchingCardGameScoreDidChange(to score: Int) {
        flipCountLabel.text = "Score: \(score)"
    }
}

