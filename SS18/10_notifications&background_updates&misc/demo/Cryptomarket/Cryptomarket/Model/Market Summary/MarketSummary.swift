//
//  MarketSummary.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct MarketSummary: Codable {
    let name: String
    let timestamp: Date
    let high: Double
    let last: Double
    let low: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "MarketName"
        case timestamp = "TimeStamp"
        case high = "High"
        case last = "Last"
        case low = "Low"
    }
}

struct MarketSummaryResult: Codable {
    let result: [MarketSummary]
    let success: Bool
}
