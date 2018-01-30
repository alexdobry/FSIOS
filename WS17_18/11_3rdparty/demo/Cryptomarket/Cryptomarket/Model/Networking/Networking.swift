//
//  Networking.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

fileprivate let base = "https://bittrex.com/api/v1.1/public/"

fileprivate extension ModelType {
    var url: URL {
        switch self {
        case .markets: return URL(string: "\(base)getmarkets")!
        case .marketSummary(let market): return URL(string: "\(base)getmarketsummary?market=\(market.name)")!
        }
    }
    
    var method: String {
        switch self {
        case .markets, .marketSummary: return "GET"
        }
    }
    
    func decode<T>(data: Data, withJsonDecoder decoder: JSONDecoder) throws -> T {
        switch self {
        case .markets: return try decoder.decode(MarketResult.self, from: data) as! T
        case .marketSummary: return try decoder.decode(MarketSummaryResult.self, from: data) as! T
        }
    }
}

final class Webservice {
    
    private let model: ModelType
    private let decoder: JSONDecoder

    init(model: ModelType, decoder: JSONDecoder = JSONDecoder()) {
        self.model = model
        self.decoder = decoder
    }
    
    func get<T>(completion: @escaping (Result<T>) -> Void) {
        var request = URLRequest(url: model.url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = model.method
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var result: Result<T>
            
            if let error = error {
                result = .failure(error)
            } else {
                do {
                    let decoded: T = try self.model.decode(data: data!, withJsonDecoder: self.decoder)
                    result = .success(decoded)
                } catch {
                    result = .failure(error)
                }
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        task.resume()
    }
}
