//
//  GameViewController.swift
//  Swiperia
//
//  Created by Edgar Gellert on 17.06.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var directionManager : DirectionManager = StandardDirectionManager()
    //var gameTimer = TimeManager
    var arrowTimer : TimeManager!
    var gameTimer : TimeManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
