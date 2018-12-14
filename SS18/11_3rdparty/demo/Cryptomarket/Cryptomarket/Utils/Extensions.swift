//
//  Extensions.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let coolGreen = #colorLiteral(red:0.55, green:0.70, blue:0.60, alpha:1.0)
    static let coolRed = #colorLiteral(red:0.97, green:0.60, blue:0.53, alpha:1.0)
    static let tintColor = #colorLiteral(red:0.97, green:0.50, blue:0.20, alpha:1.0)
}

extension Sequence {
    
    func groupBy<K : Hashable>(key: (Self.Iterator.Element) -> K) -> [K: [Self.Iterator.Element]] {
        return Dictionary(grouping: self, by: key)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}

extension Date {
    
    func plus(hour: Int) -> Date {
        return addingTimeInterval(TimeInterval(hour * 3600))
    }
}

extension DateComponents {
    
    var string: String? {
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

extension UIAlertController {
    
    static func withError(_ error: Error) -> UIAlertController {
        let alert = UIAlertController(
            title: "Server Fehler",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(
            title: "Verstanden",
            style: .cancel
        )
        
        alert.addAction(cancel)
        
        return alert
    }
}

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
