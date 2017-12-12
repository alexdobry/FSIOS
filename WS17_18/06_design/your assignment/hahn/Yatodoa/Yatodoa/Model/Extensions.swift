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
    
    static let darkDarkGrey = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    static let darkLightGrey = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    static let darkLighterGrey = #colorLiteral(red: 0.9667292228, green: 0.9667292228, blue: 0.9667292228, alpha: 1)
    static let darkHighlight = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    
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
