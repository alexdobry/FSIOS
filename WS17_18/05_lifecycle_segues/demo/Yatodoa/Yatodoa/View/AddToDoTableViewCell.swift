//
//  AddToDoTableViewCell.swift
//  Done
//
//  Created by Alex on 26.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol AddToDoTableViewCellDelegate {
    func addToDoCell(_ cell: AddToDoTableViewCell, didCreateTodo string: String?)
}

class AddToDoTableViewCell: UITableViewCell {

    static let NibName = "AddToDoTableViewCell"
    static let ReuseIdentifier = "AddToDoCellReuseIdentifier"
    
    @IBOutlet weak var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    var delegate: AddToDoTableViewCellDelegate?
}

extension AddToDoTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        delegate?.addToDoCell(self, didCreateTodo: textField.text)
        
        return true
    }
}
