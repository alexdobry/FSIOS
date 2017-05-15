//
//  Extension.swift
//  Card
//
//  Created by Alex on 09.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

infix operator -->

extension CardView {
    
    /**
     copies the internal state of `lhs` to `rhs`
     - parameter lhs: src
     - parameter rhs: dest
    */
    static func -->(lhs: CardView, rhs: CardView) {
        rhs.card = lhs.card
        rhs.disabled = lhs.disabled
        rhs.matched = lhs.matched
    }
}
