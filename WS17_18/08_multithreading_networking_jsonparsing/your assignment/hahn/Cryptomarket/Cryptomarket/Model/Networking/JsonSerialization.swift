//
//  JsonSerialization.swift
//  Cryptomarket
//
//  Created by Alex on 09.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct MarketResult: Codable {
    let success: Bool
    let result: [Market]
}

extension Market {
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency = "BaseCurrency"
        case logoUrl = "LogoUrl"
        case currency = "MarketCurrency"
        case currencyLong = "MarketCurrencyLong"
        case name = "MarketName"
        case active = "IsActive"
    }
}

struct MarketSummaryResult: Codable {
    let success: Bool
    let result: [MarketSummary]
}

extension MarketSummary {
    
    enum CodingKeys: String, CodingKey {
        case name = "MarketName"
        case timestamp = "TimeStamp"
        case high = "High"
        case last = "Last"
        case low = "Low"
        /*case volume = "Volume"
        case baseVolume = "BaseVolume"
        case bid = "Bid"
        case ask = "Ask"
        case openBuyOrders = "OpenBuyOrders"
        case openSellOrders = "OpenSellOrders"
        case prevDay = "PrevDay"
        case created = "Created"*/
    }
}
