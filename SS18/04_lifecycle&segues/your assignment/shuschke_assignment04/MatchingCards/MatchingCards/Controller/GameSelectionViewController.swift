//
//  GameSelectionViewController.swift
//  MatchingCards
//
//  Created by Alex on 02.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum Game: Int {
    case matching
    case flip
}

class GameSelectionViewController: UIViewController {
    
    private struct Storyboard {
        static let ScoreSegue = "ScoreSettingSegue"
        static let HighscoreSegue = "HighscoreSegue"
        
    }
    
    @IBOutlet weak var ScoreButton: UIBarButtonItem!
    
    // MARK: - Model
    
    //ASSIGNMENT
    var scoreList: [Int] = []
    
    lazy var matchingCardViewController = storyboard?.instantiateViewController(withIdentifier: "MatchingCardsLayoutViewControllerID") as! MatchingCardsLayoutViewController
    lazy var flipCardViewController = storyboard?.instantiateViewController(withIdentifier: "SimpleCardViewControllerID") as! SimpleCardViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showGame(at: 0)
    }
    
    @IBAction func selectGame(_ sender: UISegmentedControl) {
        showGame(at: sender.selectedSegmentIndex)
    }
    
    private func showGame(at index: Int) {
        let game = Game(rawValue: index)!
        print(game)
        
        switch game {
        case .matching:
            flipCardViewController.remove()
            add(matchingCardViewController)
            navigationItem.leftBarButtonItem?.isEnabled = true //ASSIGNMENT
        case .flip:
            matchingCardViewController.remove()
            add(flipCardViewController)
            navigationItem.leftBarButtonItem?.isEnabled = false //ASSIGNMENT
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Storyboard.ScoreSegue:
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.visibleViewController as! ScoreSettingsViewController
            
            destVC.increase = matchingCardViewController.game.scoreIncrease
            destVC.decrease = matchingCardViewController.game.scoreDecrease
        case Storyboard.HighscoreSegue:
            let destVC = segue.destination as! HighscoreViewController
            print("ScoreList in GAMESELECTION: \(scoreList)")
            destVC.scoreList = self.scoreList
        default: break
        }
    }
    
    @IBAction func unwindFromScoreSettingViewController(_ segue: UIStoryboardSegue) {
        let scoreVC = segue.source as! ScoreSettingsViewController
        
        matchingCardViewController.game.scoreIncrease = scoreVC.increase
        matchingCardViewController.game.scoreDecrease = scoreVC.decrease
    }
}
