//
//  TodoView.swift
//  Done
//
//  Created by Alex on 07.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol TodoViewDelegate {
    func todoViewHasChanged(task: String, completed: Bool, stamp: Date)
}

class TodoView: CustomView {

    @IBOutlet weak var checkbox: TDCheckbox!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    var delegate: TodoViewDelegate?
    //var parentController: TodoViewController? // FIXME: replace with delegate pattern
    
    @IBAction func buttonChecked(_ sender: TDCheckbox) {
        if let todo = textField.text, !todo.isEmpty {
            let newValue = checkbox.check()
            let now = Date()
            
            if newValue {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue
                    ])
                //textField.alpha = 0.5
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "de_DE")
                dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                
                label.text = "Letzte Änderung: \(dateFormatter.string(from: now))"
                textField.isUserInteractionEnabled = false
            } else {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.black,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleNone.rawValue
                    ])
                label.text = nil
                //textField.alpha = 1.0
                textField.isUserInteractionEnabled = true
            }
            
            delegate?.todoViewHasChanged(task: todo, completed: newValue, stamp: now)
            //parentController?.todoViewHasChanged(task: todo, completed: newValue)
        }
    }
}
