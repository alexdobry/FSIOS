//
//  FlipCardViewController.swift
//  Card
//
//  Created by Alex on 15.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class FlipCardViewController: UIViewController {

    @IBOutlet weak var flipCountLabel: UILabel!
    
    var flips: Int = 0 {
        didSet {
            flipCountLabel.text = "Flip Count \(flips)"
        }
    }
    
    var deck: Deck = Deck()
    
    @IBAction func flipCard(_ sender: CardView) {
        if sender.facedUp {
            sender.card = nil
        } else {
            sender.card = deck.drawRandomCard()
            flips += 1
        }
    }
}
