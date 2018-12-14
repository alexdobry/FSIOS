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
