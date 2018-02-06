//
//  MarketService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public final class MarketService: DataProvider {
    
    private let webservice: Webservice
    private let database: Database?
    
    public static func instance() -> MarketService {
        let model = ModelType.markets
        
        return MarketService(
            webservice: Webservice(model: model),
            database: Diskdatabase.with(model: model)
        )
    }
    
    private init(webservice: Webservice, database: Database?) {
        self.webservice = webservice
        self.database = database
    }
    
    public func model(from source: ModelSource, completion: @escaping (Result<[Market]>) -> Void) {
        switch source {
        case .database: fromDatabase(completion)
        case .network: fromNetwork(completion)
        case .both: fromDatabase(completion); fromNetwork(completion)
        }
    }
    
    private func fromDatabase(_ completion: (Result<[Market]>) -> Void) {
        if let local: [Market] = database?.getAll() {
            debugPrint(#function, "local", local.count)
            completion(.success(local))
        }
    }
    
    private func fromNetwork(_ completion: @escaping (Result<[Market]>) -> Void) {
        webservice.get { (result: Result<MarketResult>) in
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
                let markets = s.result
                
                self.database?.override(with: markets)
                
                debugPrint(#function, "web", markets.count)
                completion(.success(markets))
            }
        }
    }
}
