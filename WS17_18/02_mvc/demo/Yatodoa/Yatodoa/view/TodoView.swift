//
//  TodoView.swift
//  Done
//
//  Created by Alex on 07.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class TodoView: CustomView {

    @IBOutlet weak var checkbox: TDCheckbox!
    @IBOutlet weak var textField: UITextField!
    
    var parentController: TodoViewController? // FIXME: replace with delegate pattern
    
    @IBAction func buttonChecked(_ sender: TDCheckbox) {
        if let todo = textField.text, !todo.isEmpty {
            let newValue = checkbox.check()
            
            if newValue {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue
                    ])
                //textField.alpha = 0.5
                textField.isUserInteractionEnabled = false
            } else {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.black,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleNone.rawValue
                    ])
                //textField.alpha = 1.0
                textField.isUserInteractionEnabled = true
            }
            
            parentController?.todoViewHasChanged(task: todo, completed: newValue)
        }
    }
}
