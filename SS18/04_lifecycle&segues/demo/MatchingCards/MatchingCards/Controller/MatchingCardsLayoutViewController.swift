//
//  MatchingCardsLayoutViewController.swift
//  MatchingCards
//
//  Created by Alex on 29.03.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

infix operator -->

extension CardButton {
    
    static func -->(lhs: CardButton, rhs: CardButton) {
        rhs.cardTitle = lhs.cardTitle
        rhs.matched = lhs.matched
    }
}

class MatchingCardsLayoutViewController: UIViewController {

    private struct Constants {
        static let WaggleAnimationAngle = CGFloat.pi / 7
        static let WaggleAnimationDuration = 0.3
        static let PlayButtonAppearAnimationDuration = 1.5
        static let DealCardsAnimationDuration = 1.0
        static let DealCardsDelayDuration = 0.5
    }

    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var cards: [CardButton]!
    @IBOutlet private var portraitCards: [CardButton]!
    @IBOutlet private var landscapeCards: [CardButton]!
    @IBOutlet private weak var playAgainButton: UIButton!
    
    private var allCards: [CardButton] {
        let sizeClassDependentCardButtons: [CardButton]
        
        switch traitCollection.verticalSizeClass {
        case .compact:
            sizeClassDependentCardButtons = landscapeCards
        case .regular:
            sizeClassDependentCardButtons = portraitCards
        case .unspecified:
            fatalError("verticalSizeClass should be either compact or regular")
        }
        
        return cards + sizeClassDependentCardButtons
    }
    
    lazy var game: MatchingCardGame = MatchingCardGame(requiredCards: allCards.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        dealCards()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard let previous = previousTraitCollection?.verticalSizeClass  else { return }
        
        zip(portraitCards, landscapeCards).forEach { port, land in
            switch previous {
            case .compact: land --> port
            case .regular: port --> land
            case .unspecified: break
            }
        }
    }
    
    @IBAction func flipCard(_ sender: CardButton) {
        let index = allCards.index(of: sender)!
        
        let result = game.flipCard(at: index)
        print(result)
        
        switch result {
        case .pending(let card):
            sender.cardTitle = card.description
        case let .noMatch(first, second):
            sender.cardTitle = second.description
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in // time to think
                sender.cardTitle = nil
                self.cardButton(matching: first).cardTitle = nil
            })
            
        case let .match(first, second):
            sender.cardTitle = second.description
            
            sender.matched = true
            cardButton(matching: first).matched = true
            
        case .alreadySelected: // break
            waggle(card: sender)
        }
    }
    
    private func cardButton(matching card: Card) -> CardButton {
        return allCards.first(where: { $0.cardTitle == card.description })!
    }
    
    private func setup() { // in order to retry game
        scoreLabel.text = "Score: 0"
        playAgainButton.isHidden = true
        game.delegate = self
    }
    
    private func dealCards() {
        let duration = Constants.DealCardsAnimationDuration / 2
        let delay = 0.0 //Constants.DealCardsDelayDuration / 2
        
        allCards.forEach { card in
            let dest = CGPoint(x: view.frame.width / 2, y: view.frame.height)
            let x = card.center.x - dest.x
            let y = card.center.y - dest.y
            
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: .curveEaseInOut,
                animations: {
                    card.transform = CGAffineTransform
                        .identity
                        .translatedBy(x: -x, y: -y)
                        .scaledBy(x: -0.3, y: -0.3)
                }, completion: { _ in
                    UIView.animate(
                        withDuration: duration,
                        delay: delay,
                        options: .curveEaseInOut,
                        animations: {
                            card.transform = CGAffineTransform.identity
                        }
                    )
                }
            )
        }
    }
    
    private func showPlayAgainButton() {
        let duration = Constants.PlayButtonAppearAnimationDuration / 2
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                self.playAgainButton.isHidden = false
                self.playAgainButton.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
            }, completion: { _ in
                UIView.animate(
                    withDuration: duration,
                    delay: 0.0,
                    options: .curveEaseInOut,
                    animations: {
                        self.playAgainButton.transform = CGAffineTransform.identity
                    }
                )
            }
        )
    }
    
    private func waggle(card: CardButton) {
        let angle = Constants.WaggleAnimationAngle
        let duration = Constants.WaggleAnimationDuration / 3
        
        UIView.animate(
            withDuration: duration,
            animations: {
                card.transform = CGAffineTransform(rotationAngle: angle)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: duration,
                    animations: {
                        card.transform = CGAffineTransform(rotationAngle: -angle)
                    },
                    completion: { _ in
                        UIView.animate(withDuration: duration) {
                            card.transform = CGAffineTransform.identity
                        }
                    }
                )
            }
        )
    }
    
    private func gameOver() {
        allCards.forEach { $0.matched = true }
        showPlayAgainButton()
    }
    
    @IBAction func playAgain(_ sender: Any) {
        game = MatchingCardGame(requiredCards: allCards.count)
        allCards.forEach {
            $0.cardTitle = nil
            $0.matched = false
        }
        
        setup(); dealCards()
    }
}

extension MatchingCardsLayoutViewController: MatchingCardGameDelegate {
    func matchingCardGameScoreDidChange(to score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func matchingCardGameDidEnd(with cards: [Card]) {
        print(#function, cards)
        gameOver()
    }
}

