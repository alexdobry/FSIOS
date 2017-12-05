//
//  ToDoView.swift
//  Done
//
//  Created by Alex on 13.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol ToDoViewDelegate {
    func todoView(_ todoView: ToDoView, wasCompleted completed: Bool, withToDo todo: String)
    func todoView(_ todoView: ToDoView, didCreateTodo string: String?)
}

class ToDoView: CustomView {
    
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        return f
    }()
    
    @IBOutlet weak var finishedStackView: UIStackView! {
        didSet { finishedStackView.isHidden = true } // created todos are not done yet
    }
    
    @IBOutlet weak var checkbox: TDCheckbox!
    @IBOutlet weak var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    var delegate: ToDoViewDelegate?
    
    var todo: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var date: Date? {
        didSet {
            if let date = date {
                // CAUTION - if we only hide and unhide "finishedStackView", it will "fall from top to bot"
                
                // finishedStackView is hidden, make it also transparent to fix the "falling form the sky" bug
                finishedStackView.arrangedSubviews.forEach { $0.alpha = 0.0 }

                // set text
                let finishedLabel = finishedStackView.arrangedSubviews.flatMap { $0 as? UILabel }.first
                finishedLabel?.text = "Erledigt am \(ToDoView.formatter.string(from: date))"
                
                UIView.animate(withDuration: ViewConstants.DefaultExpandingAnimationDuration/2, animations: {
                    // let finishedStackView appear
                    self.finishedStackView.isHidden = !self.finishedStackView.isHidden
                }, completion: { bool in
                    UIView.animate(withDuration: ViewConstants.DefaultExpandingAnimationDuration/2, animations: {
                        // after finishedStackView appeared, make it fully opaque, bypassing the "falling" part
                        self.finishedStackView.arrangedSubviews.forEach { $0.alpha = 1.0 }
                    })
                })
            } else {
                // kinda the reverse animation from above
                
                // finishedStackView is visible and fully opaque
                
                UIView.animate(withDuration: ViewConstants.DefaultExpandingAnimationDuration/2, animations: {
                    // make finishedStackView transparent first
                    self.finishedStackView.arrangedSubviews.forEach { $0.alpha = 0.0 }
                }, completion: { bool in
                    UIView.animate(withDuration: ViewConstants.DefaultExpandingAnimationDuration/2, animations: {
                        // hide finishedStackView afterwards
                        self.finishedStackView.isHidden = !self.finishedStackView.isHidden
                    })
                })
            }
        }
    }
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        guard let todo = todo, !todo.isEmpty else { return }
        
        let completed = checkbox.check()
        
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
        
        delegate?.todoView(self, wasCompleted: completed, withToDo: todo)
    }
}

extension ToDoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        delegate?.todoView(self, didCreateTodo: textField.text)
        
        return true
    }
}
