//
//  ViewController.swift
//  Yatodoa
//
//  Created by Alex on 24.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var doneLabel: UILabel!
    
    var todos: [String] = [] {
        didSet {
            print(todos)
            if(todos.count == 1) {
                self.doneLabel.text = String(todos.count) + " Aufgabe erledigt"
            } else {
                self.doneLabel.text = String(todos.count) + " Aufgaben erledigt"
            }
        }
    }
    
    @IBOutlet weak var checkbox1: UIButton!
    @IBOutlet weak var checkbox2: UIButton!
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var todoTextField2: UITextField!
    
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        boxTapped(box: checkbox1, todo: todoTextField)
    }
    @IBAction func checkbox2Tapped(_ sender: UIButton) {
        boxTapped(box: checkbox2, todo: todoTextField2)
    }
    
    func boxTapped(box: UIButton, todo: UITextField) {
        if let text = todo.text, !text.isEmpty {
            if box.currentTitle == nil {
                box.setTitle("✔️", for: UIControlState.normal)
                
                todo.alpha = 0.5
                todo.isUserInteractionEnabled = false
                
                todos.append(text)
            } else {
                box.setTitle(nil, for: UIControlState.normal)
                
                todo.alpha = 1.0
                todo.isUserInteractionEnabled = true
                
                if let index = todos.index(of: text) {
                    todos.remove(at: index)
                }
            }
        }
    }
}

