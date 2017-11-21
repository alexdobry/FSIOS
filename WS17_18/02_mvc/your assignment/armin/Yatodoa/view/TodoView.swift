//
//  TodoView.swift
//  Done
//
//  Created by Alex on 07.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol TodoViewDelegate {
    func changedToDo(task:String, completed:Bool, time:Date?)
    
}

class TodoView: CustomView {

    @IBOutlet weak var checkbox: TDCheckbox!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var timestampLabel: UILabel!
    
    //var parentController: TodoViewController? // FIXME: replace with delegate pattern
    
    var delegate:TodoViewDelegate? = nil
    
    func getTimestampFormatted(timestamp:Date) -> String{
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy, HH:mm 'Uhr'"
        
        let t = f.string(from: timestamp)
        
        return "erledigt am: " + t
    }
    
    
    @IBAction func buttonChecked(_ sender: TDCheckbox) {
        if let todo = textField.text, !todo.isEmpty {
           let now = Date()
            let newValue = checkbox.check()
            
            if newValue {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue
                    ])
                //textField.alpha = 0.5
                textField.isUserInteractionEnabled = false
                timestampLabel.alpha = 1.0
                timestampLabel.text = getTimestampFormatted(timestamp:now)
            
            } else {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.black,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleNone.rawValue
                    ])
                //textField.alpha = 1.0
                textField.isUserInteractionEnabled = true
                timestampLabel.alpha = 0.0
            }
            
            if delegate != nil{
                delegate?.changedToDo(task: todo, completed: newValue, time:now)
            }

        }
    }
}
