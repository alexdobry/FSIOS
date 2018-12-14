//
//  AddTodoView.swift
//  Yatodoa
//
//  Created by Alex on 25.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol AddTodoViewDelegate {
    func addTodoView(_ view: AddTodoView, didCreateTodo task: String)
}

class AddTodoView: CustomView {
    
    @IBOutlet weak private var plusButton: UIButton! {
        didSet {
            plusButton.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        }
    }
    
    @IBOutlet weak private var textField: UITextField! {
        didSet {
            textField.placeholder = "your todo ..."
            textField.delegate = self
            textField.borderStyle = .none
        }
    }
    
    @IBOutlet weak private var topConstraint: NSLayoutConstraint!
    @IBOutlet weak private var botConstraint: NSLayoutConstraint!
    
    var delegate: AddTodoViewDelegate?
    
    var preferedHeight: CGFloat {
        return textField.frame.height + topConstraint.constant + botConstraint.constant
    }
}

extension AddTodoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let task = textField.text, !task.isEmpty {
            delegate?.addTodoView(self, didCreateTodo: task)
            textField.text = nil
        }
        
        return true
    }
}
