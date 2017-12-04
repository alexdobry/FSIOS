//
//  TodoTableViewCell.swift
//  Yatodoa
//
//  Created by Alex on 21.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol TodoTableViewCellDelegate {
    func todoCell(_ cell: TodoTableViewCell, wasCompleted completed: Bool)
}

class TodoTableViewCell: UITableViewCell {
    
    static let NibName = "TodoTableViewCell"
    static let ReuseIdentifier = "TodoTableViewCellReuseIdentifier"
    
    @IBOutlet weak var checkbox: TDCheckbox!
    @IBOutlet weak var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    var todo: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var completed: Bool = false {
        didSet{
            guard let todo = todo else { return }
            
            checkbox.checked = completed
            
            if completed {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue
                    ])
            } else {
                textField.attributedText = NSAttributedString(string: todo, attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.black,
                    NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleNone.rawValue
                    ])
            }
            
            textField.isUserInteractionEnabled = !completed
        }
    }
    
    var delegate: TodoTableViewCellDelegate?
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        guard let todo = todo, !todo.isEmpty else { return }
        
        let completed = checkbox.check()
        self.completed = completed
        
        
        
        delegate?.todoCell(self, wasCompleted: completed)
    }
}

extension TodoTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // delegate?.todoView(self, didCreateTodo: textField.text)
        
        return true
    }
}
