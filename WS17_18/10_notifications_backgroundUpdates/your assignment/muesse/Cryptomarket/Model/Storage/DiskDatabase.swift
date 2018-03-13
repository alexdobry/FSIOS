//
//  DiskDatabase.swift
//  Cryptomarket
//
//  Created by Alex on 08.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

fileprivate extension ModelType {
    var identifier: String {
        switch self {
        case .marketSummary(let market): return "MarketSummaries_\(market.name)"
        case .markets: return "Markets"
        }
    }
    
    var fileType: String {
        switch self {
        case .markets, .marketSummary: return "json"
        }
    }
}

// make them persistent
extension Market: UniqueEntitiy {}
extension MarketSummary: UniqueEntitiy {}

final class Diskdatabase: Database {
    
    private let url: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    static func with(model: ModelType) -> Diskdatabase? {
        guard let base = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
        
        return Diskdatabase(
            url: base.appendingPathComponent(model.identifier).appendingPathExtension(model.fileType),
            encoder: defaultJsonEncoder,
            decoder: defaultJsonDecoder
        )
    }
    
    private init(url: URL, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.url = url
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func getAll<Model>() -> [Model] where Model : UniqueEntitiy {
        let data = try? Data(contentsOf: url)
        let decoded = data.flatMap { try? decoder.decode([Model].self, from: $0) }
        
        return decoded ?? []
    }

    func insert<Model>(_ model: Model) -> [Model] where Model : UniqueEntitiy {
        var existing: [Model] = getAll()
        existing.append(model)
        
        override(with: existing)
        
        return existing
    }

    func override<Model>(with models: [Model]) where Model : UniqueEntitiy {
        let data = try? encoder.encode(models)
        try? data?.write(to: url)
    }
}
