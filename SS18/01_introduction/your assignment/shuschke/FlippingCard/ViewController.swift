//
//  ViewController.swift
//  FlippingCard
//
//  Created by Alex on 11.04.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet var cards: [UIButton]!
    
    var counter = 0 {
        didSet {
            counterLabel.text = "Counter: \(counter)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /*
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(flip(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(unflip(_:)))
        swipeLeft.direction = .left
        */

        for button in cards {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(flip(_:)))
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(unflip(_:)))
            swipeLeft.direction = .left
            
            button.addGestureRecognizer(swipeLeft)
            button.addGestureRecognizer(swipeRight)
        }
    }
    
    func flip(_ card: UIButton, with title: String) {
        guard let backgroundImage = card.currentBackgroundImage else {
            fatalError("card.currentBackgroundImage should be some value")
            // return
        }
            // backgroundImage is set to value
         
        switch backgroundImage {
        case #imageLiteral(resourceName: "card_front"):
            card.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            card.setTitle("", for: .normal)
            
        case #imageLiteral(resourceName: "card_back"):
            card.setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            card.setTitle(title, for: .normal)
            
        default:
            print("this should never happen")
        }
        
        counter += 1
    }
    
    @IBAction func cardTapped(_ sender: UIButton) {
        print("card tapped")
        
        flip(sender, with: "tap")
    }
    
    @IBAction func ResetButton(_ sender: UIButton) {
        counter = 0
        
        for button in cards {
            button.setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            button.setTitle("", for: .normal)
        }
    }
    
    @objc func flip(_ recognizer: UISwipeGestureRecognizer) {
        //print(#function)
        
        let button = recognizer.view as! UIButton
        if button.backgroundImage(for: .normal) == #imageLiteral(resourceName: "card_back") {
            flip(button, with: "flip \(recognizer.direction == .left ? "left" : "right")")
        }
        
    }
    
    @objc func unflip(_ recognizer: UISwipeGestureRecognizer) {
        //print(#function)
        
        let button = recognizer.view as! UIButton
        if button.backgroundImage(for: .normal) == #imageLiteral(resourceName: "card_front") {
            flip(button, with: "flip \(recognizer.direction == .left ? "left" : "right")")
        }
        
    }
}

