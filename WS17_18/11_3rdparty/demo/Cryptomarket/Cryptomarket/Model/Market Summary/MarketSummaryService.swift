//
//  MarketSummaryService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class MarketSummaryService: DataProvider {
    
    private let market: Market
    private let webservice: Webservice
    private let database: Database?
    
    static func with(market: Market) -> MarketSummaryService {
        let model = ModelType.marketSummary(market: market)
        
        return MarketSummaryService(
            market: market,
            webservice: Webservice(model: model, decoder: defaultJsonDecoder),
            database: Diskdatabase.with(model: model)
        )
    }
    
    private init(market: Market, webservice: Webservice, database: Database?) {
        self.market = market
        self.webservice = webservice
        self.database = database
    }
    
    func model(from source: ModelSource, completion: @escaping (Result<[MarketSummary]>) -> Void) {
        switch source {
        case .network: fromNetwork(completion)
        case .database: fromDatabase(completion)
        case .both: fromDatabase(completion); fromNetwork(completion)
        }
    }
    
    private func fromDatabase(_ completion: (Result<[MarketSummary]>) -> Void) {
        if let local: [MarketSummary] = database?.getAll() { // return from db first
            debugPrint(#function, "local", local.count)
            completion(.success(local))
        }
    }
    
    private func fromNetwork(_ completion: @escaping (Result<[MarketSummary]>) -> Void) {
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
                    debugPrint(#function, "db overall", all.count)
                    completion(.success(all))
                } else {
                    debugPrint(#function, "without db")
                    completion(.success([first]))
                }
            }
        }
    }
    
    func deltaFromNetwork(completion: @escaping (MarketSummaryDelta?) -> Void) {
        fromNetwork { result in
            let delta = result
                .map { $0.sorted { $0.timestamp > $1.timestamp } }
                .mapOrNil { sorted -> MarketSummaryDelta? in
                    guard let first = sorted[safe: 0],
                        let second = sorted[safe: 1]
                    else { return nil }
                    
                    return self.delta(between: first, and: second)
            }
            
            completion(delta)
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
