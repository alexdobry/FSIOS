//
//  CryptomarketKitTests.swift
//  CryptomarketKitTests
//
//  Created by Alex on 31.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import XCTest
@testable import CryptomarketKit

extension Market: Equatable {
    public static func ==(lhs: Market, rhs: Market) -> Bool {
        return lhs.baseCurrency == rhs.baseCurrency &&
            lhs.active == rhs.active &&
            lhs.currency == rhs.currency &&
            lhs.currencyLong == rhs.currencyLong &&
            lhs.logoUrl == rhs.logoUrl &&
            lhs.name == rhs.name
    }
}

class CryptomarketKitTests: XCTestCase {
    
    private func test(_ market: Market) {
        let url = CMURL.todayExtension(market: market).url!
        let model = CMURL(form: url)!
        
        switch model {
        case .todayExtension(let market2):
            XCTAssertEqual(market, market2)
            XCTAssertEqual(url, model.url)
        }
    }
    
    private func market(from int: Int) -> Market {
        return Market(
            baseCurrency: "\(int) baseCurrency",
            logoUrl: nil,
            currency: "\(int) currency",
            currencyLong: "\(int) currencyLong",
            name: "\(int) name",
            active: int % 2 == 0
        )
    }
    
    func testCMUrlBehavior() {
        (0..<100).map(market).forEach(test)
        
//        let market = Market(baseCurrency: "BTC", logoUrl: nil, currency: "SCX", currencyLong: "SwagCoins", name: "BTC-SXC", active: true)
//        singleTest(with: market)
    }
    
}
