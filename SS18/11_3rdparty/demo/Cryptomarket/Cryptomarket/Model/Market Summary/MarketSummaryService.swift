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
    private let ressource: Ressource<MarketSummaryResult>
    private let market: Market
    
    static func `default`(with market: Market) -> MarketSummaryService {
        let url = URL(string: "\(NetworkingConstants.BaseURL)getmarketsummary?market=\(market.name)")!
        
        return MarketSummaryService(
            market: market,
            webservice: Webservice(),
            ressource: Ressource<MarketSummaryResult>(url: url) { data -> MarketSummaryResult in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(isoFormatter)
                return try decoder.decode(MarketSummaryResult.self, from: data)
            }
        )
    }
    
    private init(market: Market, webservice: Webservice, ressource: Ressource<MarketSummaryResult>) {
        self.market = market
        self.webservice = webservice
        self.ressource = ressource
    }
    
    func marketSummaries(completion: @escaping (Result<[MarketSummary]>) -> Void) {
        webservice.request(ressource, completion: { (result: Result<MarketSummaryResult>) in
            switch result {
            case .success(let value):
                if value.success, let summary = value.result.first {
                    let all = self.insert(summary)
                    completion(.success(all))
                } else {
                    completion(.failure(NetworkingConstants.error(domain: "MarketSummaryService")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func marketSummaryDelta(completion: @escaping (MarketSummaryDelta?) -> Void) {
        marketSummaries { result in
            switch result {
            case .success(let summaries):
                let sorted = summaries.sorted { $0.timestamp > $1.timestamp }
                if sorted.count >= 2 {
                    let first = sorted[0]
                    let second = sorted[1]
                    let delta = self.delta(between: first, and: second)
                    
                    completion(delta)
                } else {
                    completion(nil)
                }

            case .failure:
                completion(nil)
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
    
    private func insertMany(_ marketSummaries: [MarketSummary]) -> [MarketSummary] {
        var existing = get()
        existing.append(contentsOf: marketSummaries)
        
        return persist(existing)
    }
    
    private func persist(_ existing: [MarketSummary]) -> [MarketSummary] {
        if let data = try? PropertyListEncoder().encode(existing) {
            UserDefaults.standard.set(data, forKey: market.name)
        }
        
        return existing
    }
    
    private func insert(_ marketSummary: MarketSummary) -> [MarketSummary] {
        var existing = get()
        existing.append(marketSummary)
        
        return persist(existing)
    }
    
    private func get() -> [MarketSummary] {
        guard let data = UserDefaults.standard.data(forKey: market.name),
            let summaries = try? PropertyListDecoder().decode([MarketSummary].self, from: data)
        else { return [] }
        
        return summaries
    }
}
