//
//  UserDefaults+Extension.swift
//  Cryptomarket
//
//  Created by Alex on 27.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public extension UserDefaults {
    
    static var grouped: UserDefaults {
        return UserDefaults(suiteName: "group.de.fhkoeln.inf.adv.fsios")!
    }
    
    public var market: Market? {
        get {
            let data = UserDefaults.grouped.object(forKey: #function) as? Data
            return data.flatMap { try? PropertyListDecoder().decode(Market.self, from: $0) }
        }
        set {
            let data = try? PropertyListEncoder().encode(newValue)
            UserDefaults.grouped.set(data, forKey: #function)
        }
    }
}
