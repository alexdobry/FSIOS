//
//  MarketSummaryService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class MarketSummaryService {
    
    private let webservice: Webservice
    
    static func instance(forMarket: String) -> MarketSummaryService {
        return MarketSummaryService(webservice: Webservice(ressource: .marketsummary(marketName: forMarket)))
    }
    
    private init(webservice: Webservice) {
        self.webservice = webservice
    }
    
    func marketSummaries(completion: @escaping (Result<[MarketSummary]>) -> Void) {
        webservice.get { (result: Result<MarketSummaryResult>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let s) where !s.success:
                let noData = NSError(
                    domain: #file,
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey : "Keine Daten"]
                )
                
                completion(.failure(noData))
                
            case .success(let s):
                completion(.success(s.result))
            }
        }
    }
    
    
    
    
    
    
    
    
    /*private let marketSummaries: [MarketSummary]
    
    init() {
        let now = Date()
  
        self.marketSummaries = (0..<30).map { i in
            let name: String = {
                switch i {
                case (0..<10): return "USDT-BTC"
                case (10..<20): return "USDT-XRP"
                case _: return "BTC-ENG"
                }
            }()
            
            return MarketSummary(
                name: name,
                timestamp: now.plus(hour: i),
                high: Double.random(min: 1.0, max: 100.0),
                last: Double.random(min: 1.0, max: 100.0),
                low: Double.random(min: 1.0, max: 100.0)
            )
        }
    }
    
    func marketSummaries(for market: Market) -> [MarketSummary] {
        return marketSummaries.filter { $0.name == market.name }
    }*/
    
    func delta(between first: MarketSummary, and second: MarketSummary) -> MarketSummaryDelta {
        let diff = first.last - second.last
        let pDiff = diff / second.last * 100
        
        let status: MarketSummaryDeltaStatus = {
            switch diff {
            case let zero where zero.isZero: return .neutral
            case let neg where neg.isLess(than: 0.0): return .down
            case _: return .up
            }
        }()
        
        return MarketSummaryDelta(value: diff, percent: pDiff, status: status)
    }
}
