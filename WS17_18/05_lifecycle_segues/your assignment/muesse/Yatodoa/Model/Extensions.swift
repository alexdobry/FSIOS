//
//  Extensions.swift
//  Done
//
//  Created by Alex on 27.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

extension Sequence {
    
    func groupBy<K : Hashable>(key: (Self.Iterator.Element) -> K) -> [K: [Self.Iterator.Element]] {
        var dict: [K: [Self.Iterator.Element]] = [:]
        
        forEach { elem in
            let k = key(elem)
            if case nil = dict[k]?.append(elem) { dict[k] = [elem] }
        }
        
        return dict
    }
}

extension UIColor {
    
    static let favoriteYellow = UIColor(red:1.00, green:0.84, blue:0.35, alpha:1.0)
}

extension UIViewController {
    
    var contentViewController: UIViewController {
        if let nav = self as? UINavigationController, let top = nav.topViewController {
            return top
        } else {
            return self
        }
    }
}
