//
//  Market.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Market: Codable {
    let baseCurrency: String
    let logoUrl: URL?
    let currency: String
    let currencyLong: String
    let name: String
    let active: Bool
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency = "BaseCurrency"
        case logoUrl = "LogoUrl"
        case currency = "MarketCurrency"
        case currencyLong = "MarketCurrencyLong"
        case name = "MarketName"
        case active = "IsActive"
    }
}

struct MarketResult: Codable {
    let success: Bool
    let result: [Market]
}
