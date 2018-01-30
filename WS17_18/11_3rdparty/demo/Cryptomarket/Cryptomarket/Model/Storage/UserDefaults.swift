//
//  UserDefaults.swift
//  Cryptomarket
//
//  Created by Alex on 17.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

fileprivate let MarketKey = "MarketKey"

extension UserDefaults {
    
    var market: Market? {
        get {
            let data = UserDefaults.standard.object(forKey: MarketKey) as? Data
            return data.flatMap { try? PropertyListDecoder().decode(Market.self, from: $0) }
        }
        set {
            let data = try? PropertyListEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: MarketKey)
        }
    }
}
