//
//  AddTodoTableViewCell.swift
//  Yatodoa
//
//  Created by Alex on 21.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol AddTodoTableViewCellDelegate {
    func addTodoCell(_ cell: AddTodoTableViewCell, didCreateTodo todo: String)
}

class AddTodoTableViewCell: UITableViewCell {
    
    static let NibName = "AddTodoTableViewCell"
    static let ReuseIdentifier = "AddTodoTableViewCellReuseI"

    @IBOutlet weak var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    var delegate: AddTodoTableViewCellDelegate?
}

extension AddTodoTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            delegate?.addTodoCell(self, didCreateTodo: text)
        }
        
        return true
    }
}
