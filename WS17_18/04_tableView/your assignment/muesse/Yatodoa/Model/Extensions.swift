//
//  Extensions.swift
//  Yatodoa
//
//  Created by Alex on 21.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

extension Sequence {
    
    func groupBy<K : Hashable>(key: (Element) -> K) -> [K: [Element]] {
        var dict: [K: [Element]] = [:]
        
        forEach { elem in
            let k = key(elem)
            if case nil = dict[k]?.append(elem) { dict[k] = [elem] }
        }
        
        return dict
    }
}
