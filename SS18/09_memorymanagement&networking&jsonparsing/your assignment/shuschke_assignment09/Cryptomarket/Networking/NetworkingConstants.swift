//
//  NetworkingConstants.swift
//  Cryptomarket
//
//  Created by Alex on 13.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct NetworkingConstants {
    static let BaseURL = "https://bittrex.com/api/v1.1/public/"
    static let MaketSummaryURL = "https://bittrex.com/api/v1.1/public/getmarketsummary?market=$MARKET_NAME"
    
    static func error(domain: String) -> NSError {
        return NSError(domain: domain, code: -1, userInfo: [NSLocalizedDescriptionKey : "Anfrage nicht erfolgreich"])
    }
    
}
