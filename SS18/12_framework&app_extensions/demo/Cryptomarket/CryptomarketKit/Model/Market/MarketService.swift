//
//  MarketService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public final class MarketService {

    private let webservice: Webservice
    private let ressource: Ressource<MarketResult>
    
    public static func `default`() -> MarketService {
        let url = URL(string: "\(NetworkingConstants.BaseURL)getmarkets")!
        
        return MarketService(
            webservice: Webservice(),
            ressource: Ressource<MarketResult>(url: url) { data -> MarketResult in
                try JSONDecoder().decode(MarketResult.self, from: data)
            }
        )
    }
    
    private init(webservice: Webservice, ressource: Ressource<MarketResult>) {
        self.webservice = webservice
        self.ressource = ressource
    }
    
    public func markets(completion: @escaping (Result<[Market]>) -> Void) {
        webservice.request(ressource, completion: { (result: Result<MarketResult>) in
            switch result {
            case .success(let value):
                if value.success {
                    completion(.success(value.result))
                } else {
                    completion(.failure(NetworkingConstants.error(domain: "MarketService")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
