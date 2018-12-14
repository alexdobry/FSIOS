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
    }
    
    // MARK: - Model
    
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
        case .flip:
            matchingCardViewController.remove()
            add(flipCardViewController)
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
            
        default: break
        }
    }
    
    @IBAction func unwindFromScoreSettingViewController(_ segue: UIStoryboardSegue) {
        let scoreVC = segue.source as! ScoreSettingsViewController
        
        matchingCardViewController.game.scoreIncrease = scoreVC.increase
        matchingCardViewController.game.scoreDecrease = scoreVC.decrease
    }
}
