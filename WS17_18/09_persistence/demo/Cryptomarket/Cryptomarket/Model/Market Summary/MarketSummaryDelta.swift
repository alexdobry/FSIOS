//
//  MarketSummaryDelta.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum MarketSummaryDeltaStatus {
    case up, down, neutral
    
    var string: String {
        switch self {
        case .down: return "down"
        case .up: return "up"
        case .neutral: return "neutral"
        }
    }
}

struct MarketSummaryDelta {
    let value: Double
    let percent: Double
    let status: MarketSummaryDeltaStatus
}
