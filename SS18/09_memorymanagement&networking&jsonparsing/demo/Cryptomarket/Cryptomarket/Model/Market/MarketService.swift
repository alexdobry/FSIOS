//
//  MarketService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class MarketService {
    
    func markets() -> [Market] {
        return [
            Market(baseCurrency: "USDT", logoUrl: URL(string: "https://bittrex.com/Content/img/symbols/BTC.png")!, currency: "BTC", currencyLong: "Bitcoin", name: "USDT-BTC", active: true),
            Market(baseCurrency: "USDT", logoUrl: URL(string: "https://bittrexblobstorage.blob.core.windows.net/public/a2b8eaee-2905-4478-a7a0-246f212c64c6.png")!, currency: "XRP", currencyLong: "Ripple", name: "USDT-XRP", active: true),
            Market(baseCurrency: "BTC", logoUrl: URL(string: "https://bittrexblobstorage.blob.core.windows.net/public/a7cb51db-1e6d-47f5-89b5-afbfc766b01b.png")!, currency: "ENG", currencyLong: "Enigma", name: "BTC-ENG", active: true)
        ]
    }
}
