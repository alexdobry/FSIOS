//
//  Market.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public struct Market: Codable {
    public let baseCurrency: String
    public let logoUrl: URL?
    public let currency: String
    public let currencyLong: String
    public let name: String
    public let active: Bool
}
