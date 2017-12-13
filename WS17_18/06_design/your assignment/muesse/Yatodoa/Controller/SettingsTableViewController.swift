//
//  SettingsTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 05.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var themeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        themeControl.removeAllSegments() // clear first
        
        Theme.all.forEach { theme in // insert after
            themeControl.insertSegment(withTitle: theme.title, at: theme.hashValue, animated: true)
        }
        
        let current = ThemeManager.current // set last selected
        themeControl.selectedSegmentIndex = current.hashValue
    }

    @IBAction func selectedTheme(_ sender: UISegmentedControl) {        
        let theme = Theme.all[sender.selectedSegmentIndex]
        let window = UIApplication.shared.delegate?.window!
        
        UIView.animate(withDuration: 1.0) {
            ThemeManager.current = theme
            
            window!.subviews.forEach { // nav controller needs to be reloaded
                $0.removeFromSuperview()
                window!.addSubview($0)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
