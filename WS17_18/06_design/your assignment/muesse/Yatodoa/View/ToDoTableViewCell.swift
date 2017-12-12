//
//  ToDoUITableViewCell.swift
//  Done
//
//  Created by Alex on 26.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol ToDoTableViewCellDelegate {
    func todoCell(_ cell: ToDoTableViewCell, wasCompleted completed: Bool)
    func todoCell(_ cell: ToDoTableViewCell, updatedTodo task: String)
}

class ToDoTableViewCell: UITableViewCell {

    static let NibName = "ToDoTableViewCell"
    static let ReuseIdentifier = "TodoCellReuseIdentifier"

    @IBOutlet weak var checkbox: TDCheckbox!
    @IBOutlet weak var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    var delegate: ToDoTableViewCellDelegate?
    
    var todo: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var completed: Bool = false {
        didSet {
            checkbox.checked = completed
            textField.isUserInteractionEnabled = !completed
            
            textField.attributedText = todo.map { text in
                let foregroundColor: UIColor = completed ? .lightGray : .black
                let strikethroughStyle: NSUnderlineStyle = completed ? .styleSingle : .styleNone
                
                return NSAttributedString(string: text, attributes: [
                    NSAttributedStringKey.foregroundColor: foregroundColor,
                    NSAttributedStringKey.strikethroughStyle: strikethroughStyle.rawValue
                ])
            }
        }
    }
    
    var favorized: Bool = false {
        didSet {
            backgroundColor = favorized ? UIColor.favoriteYellow.withAlphaComponent(0.5) : ThemeManager.current.cellBackgroundColor?.withAlphaComponent(0.8)
        }
    }
    
    @IBAction func checkboxTapped(_ sender: TDCheckbox) {
        guard let todo = todo, !todo.isEmpty else { return }
        
        let check = checkbox.check()
        delegate?.todoCell(self, wasCompleted: check)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkbox.checked = false
        textField.text = nil
        backgroundColor = ThemeManager.current.cellBackgroundColor?.withAlphaComponent(0.8)
    }
}

extension ToDoTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let todo = todo {
            delegate?.todoCell(self, updatedTodo: todo)
        }
        
        return true
    }
}
