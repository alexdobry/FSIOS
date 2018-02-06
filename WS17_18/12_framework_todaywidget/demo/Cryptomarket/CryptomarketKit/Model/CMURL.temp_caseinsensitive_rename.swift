//
//  CMUrl.swift
//  CryptomarketKit
//
//  Created by Alex on 31.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

internal let CMURLScheme = "MSToday"

public enum CMURL {
    case todayExtension(market: Market)
    
    public var url: URL? { // market -> url
        switch self {
        case .todayExtension(let market):
            guard let encoded = try? PropertyListEncoder().encode(market) else { return nil }
            
            return URL(string: "\(CMURLScheme)://?\(query)=\(encoded.base64EncodedString())")
        }
    }
    
    private var query: String {
        switch self {
        case .todayExtension: return "market"
        }
    }
    
    public init?(form url: URL) { // url -> market
        guard url.scheme == CMURLScheme else { return nil }
        
        if let value = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "market" })?.value,
            let market = Data(base64Encoded: value).flatMap({ try? PropertyListDecoder().decode(Market.self, from: $0) }) {
            self = .todayExtension(market: market)
        } else {
            return nil
        }
    }
}
