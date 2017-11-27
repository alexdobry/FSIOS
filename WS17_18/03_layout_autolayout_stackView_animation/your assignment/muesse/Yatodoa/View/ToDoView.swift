//
//  ToDoView.swift
//  Done
//
//  Created by Alex on 13.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

// FIXME: Assignment
protocol ToDoViewDelegate {
    func todoView(_ todoView: ToDoView, wasCompleted completed: Bool, withToDo todo: String)
    func todoView(_ todoView: ToDoView, didCreateTodo todo: String)
}

class ToDoView: CustomView {
    
    // FIXME: Assignment
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        return f
    }()
    
    @IBOutlet weak var finishedStackView: UIStackView! {
        didSet {
            finishedStackView.isHidden = true
            finishedStackView.alpha = 0.0
        }
    }
    
    @IBOutlet weak var checkbox: TDCheckbox!
    @IBOutlet weak var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    var delegate: ToDoViewDelegate?
    
    var date: Date? {
        didSet {
            if let date = date {
                // finishedStackView is invisible and transparent
                
                let label = finishedStackView.arrangedSubviews.first(where: { view in view is UILabel }) as! UILabel
                label.text = "Erledigt am \(ToDoView.formatter.string(from: date))"
                
                UIView.animate(withDuration: ViewConstants.DefaultAnimationDuration/2, animations: {
                    // make finishedStackView visible
                    self.finishedStackView.isHidden = false
                }, completion: { _ in
                    UIView.animate(withDuration: ViewConstants.DefaultAnimationDuration/2, animations: {
                        // after view takes place, make is opaque
                        self.finishedStackView.alpha = 1.0
                    })
                })
            } else {
                // kinda the reverse from above
                
                // finishedStackView is visbile
                
                UIView.animate(withDuration: ViewConstants.DefaultAnimationDuration/2, animations: {
                    // make view transparent first
                    self.finishedStackView.alpha = 0.0
                }, completion: { _ in
                    UIView.animate(withDuration: ViewConstants.DefaultAnimationDuration/2, animations: {
                        // after view is transparent, hide it's space
                        self.finishedStackView.isHidden = true
                    })
                })
            }
        }
    }
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        guard let todo = textField.text, !todo.isEmpty else { return }
        
        let checked = checkbox.check()
        
        if checked {
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
        
        textField.isUserInteractionEnabled = !checked
        
        // FIXME: Assignment
        delegate?.todoView(self, wasCompleted: checked, withToDo: todo)
    }
}

extension ToDoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // make keyboard disappear
        
        if let text = textField.text, !text.isEmpty {
            delegate?.todoView(self, didCreateTodo: text)
        }
        
        return true
    }
}
