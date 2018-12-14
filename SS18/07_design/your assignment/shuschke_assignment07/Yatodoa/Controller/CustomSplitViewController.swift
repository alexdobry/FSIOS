//
//  CustomSplitViewController.swift
//  Yatodoa
//
//  Created by Alex on 30.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class CustomSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = .allVisible // start ipad with splitscreen
        delegate = self
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        print(#function)
        return true // start with master when using iPhone. ignore on ipad
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
        if let secondayNaviController = splitViewController.viewControllers.last as? UINavigationController,
            let detailNavController = vc as? UINavigationController,
            let detailContentViewController = detailNavController.topViewController {
            secondayNaviController.pushViewController(detailContentViewController, animated: true)
            return true
        } else {
            return false
        }
    }
}
