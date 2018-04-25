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
    @IBOutlet weak var resetButton: UIButton!
    
    // MARK: - Model
    lazy var model = MatchingCardGame(numberOfCards: cardButtons.count)
    
    var gameScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
        //restartButton verstecken
        resetButton.isHidden = true
    }

    @IBAction func flipCard(_ sender: UIButton) {
        let index = cardButtons.index(of: sender)!
        
        let result = model.revealCard(at: index)
        print(result)
        
        switch result {
        case .pending(let card):
            // erste karte aufdecken
            sender.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            sender.setTitle(card.description, for: .normal)
            
            //---Button disablen, wenn aufgedeckt
            sender.isUserInteractionEnabled = false
            
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
                
                //---Button enablen, wenn kein match
                firstSender.isUserInteractionEnabled = true
            })
            
        case .gameOver:
            
            //---RestartButton anzeigen
            resetButton.isHidden = false
            
            for button in cardButtons {
                button.isUserInteractionEnabled = false
                button.alpha = 0.5
            }
            
        case .matchEnd(let card):
            resetButton.isHidden = false
            print("...matchEnd")
            
            // zweite karte aufdecken
            sender.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            sender.setTitle(card.description, for: .normal)
        }
    }
    
    //ReseteButton des Games
    @IBAction func reset(_ sender: Any) {
        resetButton.isHidden = true
        
        scoreLabel.text = "Score: 0"
        
        for card in cardButtons {
            card.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            card.isUserInteractionEnabled = true
            card.setTitle("", for: .normal)
            card.alpha = 1.0
        }
        model.redrawCards()
    }
    
    //Wenn zwei matchingCards aufgedeckt sind
    private func cardButtonMatching(card: Card) -> UIButton {
        print("cardButtonMatching()")
        return cardButtons.first(where: { cardButton in cardButton.currentTitle == card.description })!
    }
    
    //Wenn Score geändert wird
    func matchingCardGameScoreDidChange(to score: Int) {
        scoreLabel.text = "Score: \(score)"
        gameScore = score
    }
    
    //Wenn !matchingPossible 
    func gameIsOver(to score: Int) {
        
        let alert = UIAlertController(title: "End of Game", message: "Your score is \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    
}

