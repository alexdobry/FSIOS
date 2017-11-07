//
//  ViewController.swift
//  Yatodoa
//
//  Created by Alex on 24.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var todos: [String] = [] {
        didSet {
            print(todos)
        }
    }
    
    @IBOutlet weak var todoTextField: UITextField!
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        if let text = todoTextField.text, !text.isEmpty {
            if sender.currentTitle == nil {
                sender.setTitle("✔️", for: UIControlState.normal)
                
                todoTextField.alpha = 0.5
                todoTextField.isUserInteractionEnabled = false
                
                todos.append(text)
            } else {
                sender.setTitle(nil, for: UIControlState.normal)
                
                todoTextField.alpha = 1.0
                todoTextField.isUserInteractionEnabled = true
                
                if let index = todos.index(of: text) {
                    todos.remove(at: index)
                }
            }
        }
    }
}

