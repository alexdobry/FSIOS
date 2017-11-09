//
//  ViewController.swift
//  Yatodoa
//
//  Created by Armin Galinowski on 24.10.17.
//  Copyright © 2017 Armin Galinowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    func getTimestamp() -> String{
        let now = Date()
        
        let uhrzeit = DateFormatter()
        uhrzeit.timeZone = TimeZone.current
        uhrzeit.dateFormat = "HH:mm"
        
        let tag = DateFormatter()
        tag.timeZone = TimeZone.current
        tag.dateFormat="dd.MM.yyyy"
        
        
        let datum = tag.string(from: now)
        let uhr = uhrzeit.string(from: now)
        
        return "erledigt am: " + datum + " um " + uhr + " Uhr"
    }

    
    
    
    var todos: [String]=[]{
        didSet{
            print(todos)
            
            if(todos.count==0){
                statusText.text = "keine Aufgaben erledigt"
                             }
            else if(todos.count==1){
                statusText.text = "1 Aufgabe erledigt"

            }
            else{
                statusText.text = "\(todos.count) Aufgaben erledigt"
            }
            
        }
    }
    
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var stamp_1: UILabel!
    @IBOutlet weak var stamp_2: UILabel!
    
    
    @IBOutlet weak var todotextField2: UITextField!
    
    @IBAction func checkboxTapped_2(_ sender: UIButton) {
        if let text = todotextField2.text, !text.isEmpty {
            if sender.currentTitle == nil {
                sender.setTitle("✔", for: UIControlState.normal)
                
                stamp_2.text = getTimestamp()

                
                todotextField2.alpha = 0.5
                todotextField2.isUserInteractionEnabled = false
                
                todos.append(text)
              
                
            } else{
                sender.setTitle(nil, for: UIControlState.normal)
                
                stamp_2.text = ""

                
                todotextField2.alpha = 1
                todotextField2.isUserInteractionEnabled = true
                
                
                if let index = todos.index(of: text){
                    todos.remove(at: index)
                }
            }
        }

    
    }
    
    
    @IBOutlet weak var todotextField: UITextField!
   
    @IBAction func checkboxTapped(_ sender: UIButton) {
        if let text = todotextField.text, !text.isEmpty {
            if sender.currentTitle == nil {
                sender.setTitle("✔", for: UIControlState.normal)
                
                
                stamp_1.text = getTimestamp()
                
                todotextField.alpha = 0.5
               
                todotextField.isUserInteractionEnabled = false
                todotextField.attributedText = NSAttributedString(string: text, attributes: [
                    NSStrikethroughColorAttributeName : NSUnderlineStyle.styleSingle
                    ])
                
                todos.append(text)
            } else{
                sender.setTitle(nil, for: UIControlState.normal)
                
                stamp_1.text = ""
                
                todotextField.alpha = 1
                todotextField.isUserInteractionEnabled = true
                
                if let index = todos.index(of: text){
                    todos.remove(at: index)
                }
            }
        }

            
            
            
        }
        

}

