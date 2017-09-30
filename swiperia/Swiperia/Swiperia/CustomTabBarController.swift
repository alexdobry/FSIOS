//
//  CustomTabBarController.swift
//  Swiperia
//
//  Created by Edgar Gellert on 24.08.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let singlePlayerView = ((self.viewControllers?[0] as? UINavigationController)?.viewControllers.first as? GameSelectionController) {
            singlePlayerView.currentGameMode = GameMode.single
        }
        
        if let multiPlayerView = ((self.viewControllers?[1] as? UINavigationController)?.viewControllers.first as? GameSelectionController) {
            multiPlayerView.currentGameMode = GameMode.multi
        }
    }
}
