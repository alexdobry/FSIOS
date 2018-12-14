//
//  TDCheckbox.swift
//  Done
//
//  Created by Alex on 16.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class Checkbox: NSObject {
    let checkmarkColor: UIColor
    let borderColor: UIColor?
    
    init(checkmarkColor: UIColor, borderColor: UIColor?) {
        self.checkmarkColor = checkmarkColor
        self.borderColor = borderColor
    }
}

@IBDesignable
class TDCheckbox: UIButton {
    
    @IBInspectable
    var checked: Bool = false {
        didSet {
            setTitle(checked ? "✓" : nil, for: UIControlState.normal)
        }
    }
    
    @objc dynamic var checkbox: Checkbox? {
        didSet {
            guard let checkbox = checkbox else { return }
            
            if let borderColor = checkbox.borderColor { // circle
                backgroundColor = nil
                
                layer.borderWidth = 2
                layer.cornerRadius = 30 / 2
                layer.borderColor = borderColor.cgColor
            } else { // default
                backgroundColor = .lightGray
                
                layer.borderWidth = 0
                layer.cornerRadius = 0
                layer.borderColor = nil
            }
            
            setTitleColor(checkbox.checkmarkColor, for: .normal)
        }
    }
    
    func check() -> Bool {
        checked = !checked
        return checked
    }
}
