//
//  TodoView.swift
//  Done
//
//  Created by Alex on 07.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol TodoViewDelegate {
    func todoViewHasBeenToggled (task: String, completed: Bool, changed: Date?)
}

class TodoView: CustomView {

    @IBOutlet weak var checkbox: TDCheckbox!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var changedDateLabel: UILabel!
    
    var delegate: TodoViewDelegate? // FIXME: replace with delegate pattern
    
    @IBAction func buttonChecked(_ sender: TDCheckbox) {
        if let todo = textField.text, !todo.isEmpty {
            let newValue = checkbox.check()
            var changed : Date? = nil
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy - HH:mm"
            
            if newValue {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue
                    ])
                //textField.alpha = 0.5
                changed = Date()
                changedDateLabel.text = "Erledigt: \(formatter.string(from: changed!))"
                textField.isUserInteractionEnabled = false
                delegate?.todoViewHasBeenToggled(task: todo, completed: newValue, changed: changed)
            } else {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.black,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleNone.rawValue
                    ])
                //textField.alpha = 1.0
                changedDateLabel.text = ""
                textField.isUserInteractionEnabled = true
                delegate?.todoViewHasBeenToggled(task: todo, completed: newValue, changed: nil)
            }
        }
    }
}
