//
//  Extensions.swift
//  Done
//
//  Created by Alex on 27.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let favoriteYellow = UIColor(red:1.00, green:0.84, blue:0.35, alpha:1.0)
    
    static let yatodoaGreen = #colorLiteral(red:0.55, green:0.70, blue:0.60, alpha:1.0)
    static let yatodoaRed = #colorLiteral(red:0.97, green:0.60, blue:0.53, alpha:1.0)
    static let yatodoaBrown = #colorLiteral(red:0.71, green:0.59, blue:0.49, alpha:1.0)
    static let yatodoaLight = #colorLiteral(red:0.98, green:0.91, blue:0.79, alpha:1.0)
    
    static var random: UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

extension UIStoryboardSegue {
    
    var contentViewController: UIViewController {
        if let nav = destination as? UINavigationController, let topVC = nav.topViewController {
            return topVC // segue -> !nav! -> content
        } else {
            return destination // -> segue -> content
        }
    }
}
