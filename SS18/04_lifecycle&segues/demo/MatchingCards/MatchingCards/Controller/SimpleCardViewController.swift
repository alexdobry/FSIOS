//
//  SimpleCardViewController.swift
//  MatchingCards
//
//  Created by Alex on 09.04.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class SimpleCardViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet var cards: [UIButton]!
    
    private var count = 0 {
        didSet {
            counterLabel.text = "Counter: \(count)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for card in cards {
            let right = UISwipeGestureRecognizer(target: self, action: #selector(flipCard(_:)))
            let left = UISwipeGestureRecognizer(target: self, action: #selector(unflipCard(_:)))
            left.direction = .left
            
            card.addGestureRecognizer(right)
            card.addGestureRecognizer(left)
        }
    }
    
    func flip(card: UIButton, title: String) {
        switch card.currentBackgroundImage! {
        case #imageLiteral(resourceName: "card_front"):
            card.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            card.setTitle(nil, for: .normal)
        case #imageLiteral(resourceName: "card_back"):
            card.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            card.setTitle(title, for: .normal)
        default:
            print("this should never happen")
        }
        
        count += 1
    }
    
    @IBAction func cardTapped(_ sender: UIButton) {
        flip(card: sender, title: "tapped")
    }
    
    @IBAction func reset(_ sender: UIButton) {
        for card in cards {
            card.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            card.setTitle(nil, for: .normal)
        }
        
        count = 0
    }
    
    @objc func flipCard(_ recognizer: UISwipeGestureRecognizer) {
        let button = recognizer.view as! UIButton
        print(#function, button)
        
        if button.currentBackgroundImage == #imageLiteral(resourceName: "card_back") {
            print("flip")
            flip(card: button, title: "flip \(recognizer.direction == .left ? "left" : "right")")
        } else {
            print("can't flip")
        }
    }
    
    @objc func unflipCard(_ recognizer: UISwipeGestureRecognizer) {
        let button = recognizer.view as! UIButton
        print(#function, button)
        
        if button.currentBackgroundImage != #imageLiteral(resourceName: "card_back") {
            print("unflip")
            flip(card: button, title: "flip \(recognizer.direction == .left ? "left" : "right")")
        } else {
            print("can't unflip")
        }
    }
}
