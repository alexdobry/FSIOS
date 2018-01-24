//
//  Networking.swift
//  Cryptomarket
//
//  Created by Alex on 09.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

fileprivate let baseUrl = "https://bittrex.com/api/v1.1/public/"

enum Ressource {
    case markets
    case marketsummary (marketName: String)
}

fileprivate extension Ressource {
    var url: URL {
        switch self {
        case .markets: return URL(string: "\(baseUrl)getmarkets")!
        case .marketsummary (let name) : return URL(string: "\(baseUrl)getmarketsummary?market=\(name)")!
        }
    }
    
    var method: String {
        switch self {
        case .markets: return "GET"
        case .marketsummary: return "GET"
        }
    }
    
    func decode<T>(data: Data, withJsonDecoder decoder: JSONDecoder) throws -> T {
        switch self {
        case .markets: return try decoder.decode(MarketResult.self, from: data) as! T
        case .marketsummary: return try decoder.decode(MarketSummaryResult.self, from: data) as! T
        }
    }
}

final class Webservice {
    
    private let ressource: Ressource
    private let decoder: JSONDecoder
    

    
    init(ressource: Ressource, decoder: JSONDecoder = JSONDecoder()) {
        
        let isoFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //iso 8601
            return f
        }()
        
        self.ressource = ressource
        decoder.dateDecodingStrategy = .formatted(isoFormatter)
        self.decoder = decoder
    }
    
    func get<T>(completion: @escaping (Result<T>) -> Void) {
        var request = URLRequest(url: ressource.url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = ressource.method
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var result: Result<T>
            
            if let error = error {
                result = .failure(error)
            } else {
                do {
                    let t: T = try self.ressource.decode(data: data!, withJsonDecoder: self.decoder)
                    result = .success(t)
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
