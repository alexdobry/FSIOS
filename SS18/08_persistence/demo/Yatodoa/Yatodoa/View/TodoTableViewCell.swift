//
//  TodoUITableViewCell.swift
//  Done
//
//  Created by Alex on 26.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol TodoTableViewCellDelegate {
    func todoCell(_ cell: TodoTableViewCell, wasCompleted completed: Bool)
    func todoCell(_ cell: TodoTableViewCell, updatedTodo task: String)
}

class TodoTableViewCell: UITableViewCell {

    static let NibName = "TodoTableViewCell"
    static let ReuseIdentifier = "TodoCellReuseIdentifier"
    
    private static let TagSeparator = ", "
    
    @IBOutlet weak private var outerStackView: UIStackView!
    @IBOutlet weak private var tagLabel: UILabel!
    @IBOutlet weak private var checkbox: TDCheckbox!
    @IBOutlet weak private var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    var delegate: TodoTableViewCellDelegate?
    
    var todo: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var completed: Bool {
        get {
            return checkbox.checked
        }
        set {
            checkbox.checked = newValue
            textField.isUserInteractionEnabled = !newValue
            
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
    
    var tags: [String] {
        get {
            return tagLabel.text?.components(separatedBy: TodoTableViewCell.TagSeparator) ?? []
        }
        set {
            if !newValue.isEmpty {
                outerStackView.addArrangedSubview(tagLabel)
                tagLabel.text = newValue.joined(separator: TodoTableViewCell.TagSeparator)
            } else {
                tagLabel.text = nil
                outerStackView.removeArrangedSubview(tagLabel)
            }
        }
    }
    
    var favorized: Bool {
        get { return backgroundColor != nil }
        set { backgroundColor = newValue ? UIColor.favoriteYellow.withAlphaComponent(0.5) : nil }
    }
    
    @IBAction func checkboxTapped(_ sender: TDCheckbox) {
        guard let todo = todo, !todo.isEmpty else { return }
        delegate?.todoCell(self, wasCompleted: !completed) // don't change state here
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkbox.checked = false
        textField.text = nil
        backgroundColor = nil
    }
}

extension TodoTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let todo = todo {
            delegate?.todoCell(self, updatedTodo: todo)
        }
        
        return true
    }
}
