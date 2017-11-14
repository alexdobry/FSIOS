//
//  TDCheckbox.swift
//  Done
//
//  Created by Alex on 07.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

@IBDesignable
class TDCheckbox: UIButton {
    
    @IBInspectable
    var checked: Bool = false {
        didSet {
            setTitle(checked ? "✔️" : nil, for: UIControlState.normal)
        }
    }
    
    func check() -> Bool {
        checked = !checked
        return checked
    }
}
