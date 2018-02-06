//
//  DataProvider.swift
//  Cryptomarket
//
//  Created by Alex on 12.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public enum ModelSource {
    case database, network(storage: Bool), both
}

public protocol DataProvider {
    associatedtype Model
    
    func model(from source: ModelSource, completion: @escaping (Result<[Model]>) -> Void)
}
