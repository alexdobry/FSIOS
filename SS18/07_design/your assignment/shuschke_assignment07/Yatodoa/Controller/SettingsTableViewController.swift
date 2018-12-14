//
//  SettingsTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 30.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak private var themeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        themeControl.removeAllSegments() // clear
        
        Theme.all.forEach { theme in
            themeControl.insertSegment(withTitle: theme.title, at: theme.hashValue, animated: true)
        }
        
        let current = ThemeManager.current
        themeControl.selectedSegmentIndex = current.hashValue
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        preferredContentSize = tableView.contentSize
    }

    @IBAction func selectedTheme(_ sender: UISegmentedControl) {
        let theme = Theme.all[sender.selectedSegmentIndex]
        let window = UIApplication.shared.delegate?.window!
        
        UIView.animate(withDuration: 0.5) {
            ThemeManager.current = theme
            
            window!.subviews.forEach {
                $0.removeFromSuperview()
                window!.addSubview($0)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
