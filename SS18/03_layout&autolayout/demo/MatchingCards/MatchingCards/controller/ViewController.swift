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
    @IBOutlet var portaitCards: [CardButton]! // any/r
    @IBOutlet var landscapeCards: [CardButton]! // any/c
    @IBOutlet var cardButtons: [CardButton]! // any/any
    @IBOutlet weak var playAgainButton: UIButton!
    
    var currentVisbleCards: [CardButton] {
        let sizeClassDependentCards: [CardButton]
        
        switch traitCollection.verticalSizeClass {
        case .compact:
            sizeClassDependentCards = landscapeCards
        case .regular:
            sizeClassDependentCards = portaitCards
        case .unspecified:
            fatalError("this should never happen")
        }
        
        return cardButtons + sizeClassDependentCards
    }
    
    // MARK: - Model
    lazy var game = MatchingCardGame(numberOfCards: currentVisbleCards.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        dealCards()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if let previous = previousTraitCollection {
            zip(landscapeCards, portaitCards).forEach { land, port in
                switch previous.verticalSizeClass {
                case .compact:
                    port.cardTitle = land.cardTitle
                    port.matched = land.matched
                    
                case .regular:
                    land.cardTitle = port.cardTitle
                    land.matched = port.matched
                case .unspecified: break
                }
            }
        }
    }

    @IBAction func flipCard(_ sender: CardButton) {
        let index = currentVisbleCards.index(of: sender)!
        
        let result = game.revealCard(at: index)
        
        print(result)
        
        switch result {
        case .pending(let card):
            // erste karte aufdecken
            sender.cardTitle = card.description
            
        case .match(let first, let second):
            //  zweite karte aufdecken
            sender.cardTitle = second.description
            
            // beide karten als match markieren
            sender.matched = true
            cardButtonMatching(card: first).matched = true
            
        case .noMatch(let first, let second):
            // zweite karte aufdecken
            sender.cardTitle = second.description
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
                // beide karten zudecken
                sender.cardTitle = nil
                self.cardButtonMatching(card: first).cardTitle = nil
            })
            
        case .alreadySelected(let card):
            sender.cardTitle = "NOPE"
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                sender.cardTitle = card.description
            })
        }
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        game = MatchingCardGame(numberOfCards: currentVisbleCards.count)
        currentVisbleCards.forEach { card in
            card.cardTitle = nil
            card.matched = false
        }
        
        setup()
    }
    
    private func cardButtonMatching(card: Card) -> CardButton {
        return currentVisbleCards.first(where: { cardButton in cardButton.currentTitle == card.description })!
    }
    
    func matchingCardGameScoreDidChange(to score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func matchingCardGameDidEnd(with cards: [Card]) {
        print(#function, cards)
        
        currentVisbleCards.forEach {
            $0.matched = true
        }
        
        playAgainButton.isHidden = false
    }
    
    private func setup() {
        scoreLabel.text = "Score: 0"
        playAgainButton.isHidden = true
        game.delegate = self
    }
    
    private func dealCards() {
        currentVisbleCards.forEach { card in
            let dest = CGPoint(x: view.frame.width / 2, y: view.frame.height)
            let x = card.center.x - dest.x
            let y = card.center.y - dest.y
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                options: .curveEaseInOut,
                animations: {
                    card.transform = CGAffineTransform.identity
                        .translatedBy(x: -x, y: -y)
                        .scaledBy(x: -0.3, y: -0.3)
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: 0.5,
                        delay: 0.2,
                        options: .curveEaseInOut,
                        animations: {
                            card.transform = CGAffineTransform.identity // undo first transform
                        },
                        completion: nil
                    )
                }
            )
        }
    }
}

