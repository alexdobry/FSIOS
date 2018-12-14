//
//  AddTodoView.swift
//  Yatodoa
//
//  Created by Alex on 30.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol AddTodoViewDelegate {
    func addTodoView(_ view: AddTodoView, didCreateTodo text: String)
}

class AddTodoView: CustomView {

    @IBOutlet weak private var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    @IBOutlet weak private var botConstraint: NSLayoutConstraint!
    @IBOutlet weak private var topConstraint: NSLayoutConstraint!
    
    var delegate: AddTodoViewDelegate?
    
    var preferedHeight: CGFloat {
        return textField.frame.height + botConstraint.constant + topConstraint.constant
    }
}

extension AddTodoView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            delegate?.addTodoView(self, didCreateTodo: text)
            textField.text = nil
        }
        
        return true
    }
}
