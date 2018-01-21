//
//  DiskDatabase.swift
//  Cryptomarket
//
//  Created by Alex on 16.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum StorageKey {
    case markets, marketSummary(market: Market)
}

fileprivate extension StorageKey {
    var identifier: String {
        switch self {
        case .markets: return "Markets"
        case .marketSummary(let market): return "MarketSummary_\(market.name)"
        }
        
    }
    
    var fileExtension: String {
        switch self {
        case .markets, .marketSummary: return "json"
        }
    }
}

extension Market: UniqueEntity {}
extension MarketSummary: UniqueEntity {}

final class DiskDatabase: Database {
    
    let url: URL
    let storageKey: StorageKey
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    static func with(storageKey: StorageKey) -> DiskDatabase? {
        guard let baseUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
        
        let url = baseUrl.appendingPathComponent(storageKey.identifier).appendingPathExtension(storageKey.fileExtension)
        
        debugPrint(#function, url)
        
        // .../documents/Markets.data
        // .../documents/MarketSummary_BTC-USDT.data
        // .../documents/MarketSummary_BTC-XRP.data
        
        return DiskDatabase(
            url: url,
            storageKey: storageKey,
            encoder: defaultJsonEncoder,
            decoder: defaultJsonDecoder
        )
    }
    
    private init(url: URL, storageKey: StorageKey, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.url = url
        self.storageKey = storageKey
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func getAll<Model>() -> [Model] where Model : UniqueEntity {
        // url -> data -> model
        
        let data = try? Data(contentsOf: url)
        let decoded = data.flatMap { try? decoder.decode([Model].self, from: $0) }
        
        return decoded ?? []
    }
    
    func insert<Model>(_ model: Model) -> [Model] where Model : UniqueEntity {
        // getAll -> append model -> data -> url
        
        var existing: [Model] = getAll()
        existing.append(model)
        
        override(existing)
        
        return existing
    }
    
    func override<Model>(_ models: [Model]) where Model : UniqueEntity {
        // models -> data -> url
        
        let data = try? encoder.encode(models)
        try? data?.write(to: url)
    }
}
