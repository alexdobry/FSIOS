//
//  MarketSummary.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public struct MarketSummary: Codable {
    public let name: String
    public let timestamp: Date
    public let high: Double
    public let last: Double
    public let low: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "MarketName"
        case timestamp = "TimeStamp"
        case high = "High"
        case last = "Last"
        case low = "Low"
    }
}

public struct MarketSummaryResult: Codable {
    public let result: [MarketSummary]
    public let success: Bool
}
