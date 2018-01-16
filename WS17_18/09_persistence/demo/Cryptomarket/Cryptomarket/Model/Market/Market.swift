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
}
