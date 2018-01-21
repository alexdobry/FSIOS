//
//  MarketService.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class MarketService: DataProvider {
    
    private let webservice: Webservice
    private let database: Database?
    
    static func instance() -> MarketService {
        return MarketService(
            webservice: Webservice(ressource: .markets), // consider refactoring
            database: DiskDatabase.with(storageKey: .markets)
        )
    }
    
    private init(webservice: Webservice, database: Database?) {
        self.webservice = webservice
        self.database = database
    }
    
    typealias Model = Market
    
    func model(from source: Source, completion: @escaping (Result<[Market]>) -> Void) {
        switch source {
        case .network: fromNetwork(completion)
        case .database: fromDatabase(completion)
        case .both: fromDatabase(completion); fromNetwork(completion)
        }
    }
    
    private func fromDatabase(_ completion: @escaping (Result<[Market]>) -> Void) {
        debugPrint(#function)
        
        let all: [Market] = database?.getAll() ?? []
        
        completion(.success(all))
    }
    
    private func fromNetwork(_ completion: @escaping (Result<[Market]>) -> Void) {
        debugPrint(#function)
        
        webservice.get { (result: Result<MarketResult>) in
            switch result {
            case let .failure(e):
                completion(.failure(e))
            case let .success(s) where !s.success:
                let notSuccessful = NSError(
                    domain: #file,
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey : "Anfrage nicht erfolgreich"]
                )
                
                completion(.failure(notSuccessful))
                
            case let .success(s):
                let markets = s.result
                
                self.database?.override(markets)
                
                completion(.success(markets))
            }
        }
    }
}
