//
//  ScoreSettingsViewController.swift
//  MatchingCards
//
//  Created by Alex on 02.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ScoreSettingsViewController: UIViewController {

    // MARK:- gets prepared by segue
    var increase: Int = 0
    var decrease: Int = 0
    
    @IBOutlet weak private var increaseLabel: UILabel!
    @IBOutlet weak private var decreaseLabel: UILabel!
    
    @IBOutlet weak private var increaseStepper: UIStepper!
    @IBOutlet weak private var decreaseStepper: UIStepper!
    
    @IBOutlet weak private var botConstraint: NSLayoutConstraint!
    @IBOutlet weak private var topConstraint: NSLayoutConstraint!
    @IBOutlet weak private var topLevelStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        increaseStepper.value = Double(increase)
        decreaseStepper.value = Double(decrease)
        
        increaseScore(increaseStepper)
        decreaseScore(decreaseStepper)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController?.popoverPresentationController?.arrowDirection != .unknown {
            navigationItem.leftBarButtonItem = nil
            
            let totalHeight = increaseStepper.frame.height + decreaseStepper.frame.height + botConstraint.constant + topConstraint.constant + topLevelStackView.spacing
            
            preferredContentSize = CGSize(width: view.frame.width, height: totalHeight)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func increaseScore(_ sender: UIStepper) {
        increaseLabel.text = "Success increases Score by \(Int(sender.value))"
    }
    @IBAction func decreaseScore(_ sender: UIStepper) {
        decreaseLabel.text = "Failure decreases Score by \(Int(sender.value))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "UnwindSegue" else { return }
        
        increase = Int(increaseStepper.value)
        decrease = Int(decreaseStepper.value)
    }
}
