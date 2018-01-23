//
//  JsonSerialization.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

let defaultJsonDecoder: JSONDecoder = {
    let d = JSONDecoder()
    d.dateDecodingStrategy = .formatted(isoFormatter)
    return d
}()

let defaultJsonEncoder: JSONEncoder = {
    let e = JSONEncoder()
    e.dateEncodingStrategy = .formatted(isoFormatter)
    return e
}()

struct MarketResult: Decodable {
    let result: [Market]
    let success: Bool
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

struct MarketSummaryResult: Decodable {
    let result: [MarketSummary]
    let success: Bool
}

extension MarketSummary {
    enum CodingKeys: String, CodingKey {
        case name = "MarketName"
        case timestamp = "TimeStamp"
        case high = "High"
        case last = "Last"
        case low = "Low"
    }
}
