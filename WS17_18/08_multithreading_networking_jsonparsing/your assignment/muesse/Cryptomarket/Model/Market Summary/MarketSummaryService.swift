//
//  MarketSummaryService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class MarketSummaryService {
    
    private let marketSummaries: [MarketSummary]
    
    
    private let webservice: Webservice
    
    static func instance(name: String) -> MarketSummaryService {
        return MarketSummaryService(webservice: Webservice(ressource: .market(name: name), decoder: defaultJsonDecoder))
    }
    
    private init(webservice: Webservice) {
        self.webservice = webservice
        self.marketSummaries = []
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
