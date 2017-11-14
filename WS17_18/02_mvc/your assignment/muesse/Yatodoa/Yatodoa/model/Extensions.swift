//
//  Extensions.swift
//  Yatodoa
//
//  Created by Alex on 07.11.17.
//  Copyright © 2017 Uwe Müsse. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func remove(element: Element) -> Element? {
        if let index = index(of: element) {
            return remove(at: index)
        } else {
            return nil
        }
    }
}
