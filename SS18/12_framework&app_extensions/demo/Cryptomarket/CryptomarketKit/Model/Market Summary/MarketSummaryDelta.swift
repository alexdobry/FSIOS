//
//  MarketSummaryDelta.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public enum MarketSummaryDeltaStatus {
    case up, down, neutral
    
    var string: String {
        switch self {
        case .down: return "down"
        case .up: return "up"
        case .neutral: return "neutral"
        }
    }
}

public struct MarketSummaryDelta {
    public let value: Double
    public let percent: Double
    public let status: MarketSummaryDeltaStatus
}
