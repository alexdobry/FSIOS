//
//  CustomSplitViewController.swift
//  Yatodoa
//
//  Created by Alex on 25.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class CustomSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = .allVisible
        delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        debugPrint(#function)
        
        return true // show primaryViewController at start
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
        debugPrint(#function)
        
        if let secondaryNavController = splitViewController.viewControllers.last as? UINavigationController,
            let detailNavController = vc as? UINavigationController,
            let detailContentController = detailNavController.topViewController {
            secondaryNavController.pushViewController(detailContentController, animated: true)
            return true // presenting vc is handled by myself
        } else {
            return false // splitViewController should handle
        }
    }
}
