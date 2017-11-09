//
//  ViewController.swift
//  Yatodoa
//
//  Created by Uwe Müsse on 24.10.17.
//  Copyright © 2017 Uwe Müsse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var solved: UILabel!
    var todos: [String] = [] {
        didSet {
            let count = todos.count
            solved.text = (count == 1) ? "\(count) Aufgabe erledigt" : "\(count) Aufgaben erledigt"
        }
    }

    @IBOutlet weak var todoTextfield: UITextField!
    @IBOutlet weak var todoTextfield2: UITextField!
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        
        checkboxHandling(sender, todoTextfield);
        
    }
    @IBAction func checkbox2Tapped(_ sender: UIButton) {
        
        checkboxHandling(sender, todoTextfield2);
        
    }
    
    private func checkboxHandling (_ sender: UIButton, _ todoTextfield: UITextField){
        
        if let text = todoTextfield.text, !text.isEmpty{
            if sender.currentTitle == nil {
                sender.setTitle("✔", for: UIControlState.normal)
                todoTextfield.alpha = 0.5
                todoTextfield.isUserInteractionEnabled = false
                todoTextfield.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue])
                todos.append(text)
            } else {
                sender.setTitle(nil, for: UIControlState.normal)
                todoTextfield.alpha = 1.0
                todoTextfield.isUserInteractionEnabled = true
                todoTextfield.attributedText = NSAttributedString(string: text)
                
                if let index = todos.index(of: text) {
                    todos.remove(at: index)
                }
                
            }
        }
        
    }
    
}

