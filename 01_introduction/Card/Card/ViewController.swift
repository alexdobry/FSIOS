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
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var flipCountLabel: UILabel!
    
    // MARK: properties
    
    var flipCount: Int = 0 {
        didSet {
            flipCountLabel.text = "Flip Count: \(flipCount)"
        }
    }
    
    // MARK: target-action
    
    @IBAction func flipCard(_ sender: UIButton) {
        flip(button: sender)
    }
    
    // MARK: private functions
    
    func flip(button: UIButton) {
        if button.currentTitle != nil { // front
            button.setBackgroundImage(#imageLiteral(resourceName: "back"), for: .normal)
            button.backgroundColor = nil
            button.setTitle(nil, for: .normal)
        } else {
            button.setBackgroundImage(nil, for: .normal)
            button.backgroundColor = .lightGray
            button.setTitle("Title", for: .normal)
            
            flipCount += 1
        }
    }
}

