//
//  GamePageViewController.swift
//  Card
//
//  Created by Alex on 15.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum Game: Int {
    case matching = 0
    case flip = 1
}

extension Game {
    
    var storyboardIdentifier: String {
        switch self {
        case .matching: return "MatchingCardGameViewController"
        case .flip: return "FlipCardViewController"
        }
    }
    
    var direction: UIPageViewControllerNavigationDirection {
        if case self = Game.matching {
            return .reverse
        } else {
            return .forward
        }
    }
}

class GamePageViewController: UIPageViewController {

    var games: [Game: UIViewController] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        initWithFirstGame()
    }
    
    func initWithFirstGame() {
        selectGame(atIndex: 0)
    }
    
    func selectGame(atIndex index: Int) {
        guard let game = Game(rawValue: index) else { return }
        
        let vc = resolveViewController(for: game)
        
        self.setViewControllers([vc], direction: game.direction, animated: true, completion: nil)
    }
    
    fileprivate func resolveViewController(for game: Game) -> UIViewController {
        if let cachedVC = games[game] {
            return cachedVC
        } else {
            let vc = storyboard!.instantiateViewController(withIdentifier: game.storyboardIdentifier)
            games[game] = vc
            return vc
        }
    }
}

extension GamePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController is MatchingCardGameViewController {
            return resolveViewController(for: .flip)
        } else {
            return nil
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController is FlipCardViewController {
            return resolveViewController(for: .matching)
        } else {
            return nil
        }
    }
}
