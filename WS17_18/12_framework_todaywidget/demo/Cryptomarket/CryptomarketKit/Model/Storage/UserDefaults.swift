//
//  UserDefaults.swift
//  Cryptomarket
//
//  Created by Alex on 17.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

fileprivate let MarketKey = "MarketKey"
fileprivate let AppGroupName = "group.de.fhkoeln.inf.adv.fsios"

public extension UserDefaults {
    
    public static var grouped: UserDefaults {
        return UserDefaults(suiteName: AppGroupName)!
    }
    
    public var market: Market? {
        get {
            let data = object(forKey: MarketKey) as? Data
            return data.flatMap { try? PropertyListDecoder().decode(Market.self, from: $0) }
        }
        set {
            let data = try? PropertyListEncoder().encode(newValue)
            set(data, forKey: MarketKey)
        }
    }
}
