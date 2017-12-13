//
//  AddToDoTableViewCell.swift
//  Done
//
//  Created by Alex on 26.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol AddItemTableViewCellDelegate {
    func addItemCell(_ cell: AddItemTableViewCell, didCreateItem string: String?)
}

class AddItemTableViewCell: UITableViewCell {

    static let NibName = "AddItemTableViewCell"
    static let ReuseIdentifier = "AddItemCellReuseIdentifier"
    
    @IBOutlet weak var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    var placeholder: String? {
        didSet { textField.placeholder = placeholder }
    }
    
    var delegate: AddItemTableViewCellDelegate?
}

extension AddItemTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        delegate?.addItemCell(self, didCreateItem: textField.text)
        
        textField.text = nil
        
        return true
    }
}
