//
//  Extension.swift
//  ADV
//
//  Created by Alex on 14.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    
    func groupBy<K : Hashable>(key: (Element) -> K) -> [K: [Element]] {
        var dict: [K: [Element]] = [:]
        
        forEach { elem in
            let k = key(elem)
            if case nil = dict[k]?.append(elem) { dict[k] = [elem] }
        }
        
        return dict
    }
}

extension UIStoryboardSegue {
    
    var contentViewController: UIViewController? {
        if let nav = destination as? UINavigationController {
            return nav.topViewController
        } else {
            return destination
        }
    }
}
