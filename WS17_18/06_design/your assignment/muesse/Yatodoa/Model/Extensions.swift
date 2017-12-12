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
    
    static let favoriteYellow = #colorLiteral(red:1.00, green:0.84, blue:0.35, alpha:1.0)
    
    static let yatodoaGreen = #colorLiteral(red:0.55, green:0.70, blue:0.60, alpha:1.0)
    static let yatodoaRed = #colorLiteral(red:0.97, green:0.60, blue:0.53, alpha:1.0)
    static let yatodoaBrown = #colorLiteral(red:0.71, green:0.59, blue:0.49, alpha:1.0)
    static let yatodoaLight = #colorLiteral(red:0.98, green:0.91, blue:0.79, alpha:1.0)
    
    static let yatodoaDarkGrey = #colorLiteral(red: 0.3569444716, green: 0.4006477892, blue: 0.4248493016, alpha: 1)
    static let yatodoaLightGrey = #colorLiteral(red: 0.7415053844, green: 0.7766856551, blue: 0.7565159202, alpha: 1)
    static let yatodoaHighlightColor = #colorLiteral(red: 0.8300378919, green: 0.5325424671, blue: 0.4443281591, alpha: 1)
    static let yatodoaMediumGrey = #colorLiteral(red: 0.4943222404, green: 0.5337756872, blue: 0.5378504992, alpha: 1)
    static let yatodoaDarkBack = #colorLiteral(red: 0.07831241935, green: 0.1501133144, blue: 0.2021654844, alpha: 1)
    
    static var random: UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

extension UIViewController {
    
    var contentViewController: UIViewController {
        if let nav = self as? UINavigationController, let topVC = nav.topViewController {
            return topVC
        } else {
            return self
        }
    }
}
