//
//  Extensions.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    public static let coolGreen = #colorLiteral(red:0.55, green:0.70, blue:0.60, alpha:1.0)
    public static let coolRed = #colorLiteral(red:0.97, green:0.60, blue:0.53, alpha:1.0)
    public static let tintColor = #colorLiteral(red:0.97, green:0.50, blue:0.20, alpha:1.0)
}

public extension Sequence {
    
    public func groupBy<K : Hashable>(key: (Self.Iterator.Element) -> K) -> [K: [Self.Iterator.Element]] {
        var dict: [K: [Self.Iterator.Element]] = [:]
        
        forEach { elem in
            let k = key(elem)
            if case nil = dict[k]?.append(elem) { dict[k] = [elem] }
        }
        
        return dict
    }
}

public extension Array {
    public subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}

extension Date {
    
    func plus(hour: Int) -> Date {
        return addingTimeInterval(TimeInterval(hour * 3600))
    }
}

public extension DateComponents {
    
    public var string: String? {
        guard let month = self.month, let year = self.year, let day = self.day else { return nil }
        
        let calendar = Calendar.current
        let isOtherYear = year != calendar.component(.year, from: Date())
        let monthAndDayString = "\(day). \(calendar.monthSymbols[month - 1])"
        
        return isOtherYear ? "\(monthAndDayString) \(year)" : monthAndDayString
    }
}

extension Double {
    
    static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }

    static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

public extension UIStoryboardSegue {
    public var contentViewController: UIViewController {
        if let nav = destination as? UINavigationController, let topVC = nav.topViewController {
            return topVC
        } else {
            return destination
        }
    }
}

public extension UIViewController {
    
    public func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    public func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
