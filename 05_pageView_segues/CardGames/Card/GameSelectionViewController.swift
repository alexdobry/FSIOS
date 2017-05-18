//
//  GameSelectionViewController.swift
//  Card
//
//  Created by Alex on 15.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class GameSelectionViewController: UIViewController {
    
    @IBOutlet weak var gamesControl: UISegmentedControl!
    
    var pageViewController: GamePageViewController? {
        didSet { pageViewController?.delegate = self }
    }
    
    private struct Storyboard {
        static let EmbeddedSegueIdentifier = "Embedded Segue"
        static let ShowSettingsSegueIdentifier = "Show Settings"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Storyboard.EmbeddedSegueIdentifier:
            guard let pvc = segue.destination as? GamePageViewController else { return }
            
            self.pageViewController = pvc
            
        case Storyboard.ShowSettingsSegueIdentifier:
            guard let ssvc = segue.contentViewController as? ScoreSettingViewController else { return }
            guard let mcgvc = pageViewController?.games[.matching] as? MatchingCardGameViewController,
                let game = mcgvc.game else { return }
            
            ssvc.values = (Float(game.incrementScore), Float(game.decrementScore))
        default: break
        }
    }
    
    @IBAction func applyScoreSetting(sender: UIStoryboardSegue) {
        guard let scoreVC = sender.source as? ScoreSettingViewController,
            let scores = scoreVC.values
        else { return }
        
        guard let mcgvc = pageViewController?.games[.matching] as? MatchingCardGameViewController else { return }
        
        mcgvc.game?.incrementScore = Int(scores.increment)
        mcgvc.game?.decrementScore = Int(scores.decrement)
    }
    
    @IBAction func selectGame(_ sender: UISegmentedControl) {
        pageViewController?.selectGame(atIndex: sender.selectedSegmentIndex)
    }
}

extension GameSelectionViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished && completed else { return }
        
        if let _ = previousViewControllers.first as? FlipCardViewController {
            gamesControl.selectedSegmentIndex = 0
        } else {
            gamesControl.selectedSegmentIndex = 1
        }
    }
}
