//
//  CardView.swift
//  Card
//
//  Created by Alex on 09.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIButton {
    
    @IBInspectable
    var disabled: Bool = false {
        didSet {
            if disabled {
                isUserInteractionEnabled = false
                alpha = 0.5
            }
        }
    }
    
    @IBInspectable
    var matched: Bool = false {
        didSet {
            if matched {
                layer.cornerRadius = 5
                layer.borderWidth = 3
                layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    var facedUp: Bool {
        return currentTitle != nil
    }

    var card: Card? { didSet { updateUI() } }
    
    private func updateUI() {
        if let card = card {
            setBackgroundImage(nil, for: .normal)
            backgroundColor = .lightGray
            setTitle(card.description, for: .normal)
        } else {
            setBackgroundImage(#imageLiteral(resourceName: "back"), for: .normal)
            backgroundColor = nil
            setTitle(nil, for: .normal)
        }
    }
}
