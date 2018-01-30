//
//  MarketSummaryService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class MarketSummaryService {
    
    private let market: Market
    private let webservice: Webservice
    private let database: Database?
    
    static func with(market: Market) -> MarketSummaryService {
        return MarketSummaryService(
            market: market,
            webservice: Webservice(ressource: .marketSummary(market: market), decoder: defaultJsonDecoder),
            database: DiskDatabase.with(storageKey: .marketSummary(market: market))
        )
    }
    
    private init(market: Market, webservice: Webservice, database: Database?) {
        self.market = market
        self.webservice = webservice
        self.database = database
    }
    
    func marketSummaries(completion: @escaping (Result<[MarketSummary]>) -> Void) {
        webservice.get { (result: Result<MarketSummaryResult>) in
            switch result {
            case let .failure(e):
                completion(.failure(e))
                
            case let .success(s) where !s.success:
                let notSuccessful = NSError(
                    domain: #file,
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey : "Anfrage war nicht erfolgreich"]
                )
                
                completion(.failure(notSuccessful))
                
            case let .success(s):
                let first = s.result.first!
                
                if let all = self.database?.insert(first) {
                    debugPrint(#function, "fromDb")
                    completion(.success(all))
                } else {
                    debugPrint(#function, "not db")
                    completion(.success([first]))
                }
            }
        }
    }
    
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
