//
//  HighscoreViewController.swift
//  MatchingCards
//
//  Created by Alexander Dobrynin on 17.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController {

    var scoreList: [Int] = []
    var score: Int = 0
    var i: Int = 0
    
    @IBOutlet weak var highscoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Scores in HSVC: \(scoreList)")
       
       
    }
    
    

    
    

}
