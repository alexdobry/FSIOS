//
//  MarketService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class MarketService {
    
    private let webservice: Webservice
    
    static func instance() -> MarketService {
        return MarketService(webservice: Webservice(ressource: .markets))
    }
    
    private init(webservice: Webservice) {
        self.webservice = webservice
    }
    
    func markets(completion: @escaping (Result<[Market]>) -> Void) {
        webservice.get { (result: Result<MarketResult>) in
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
}
