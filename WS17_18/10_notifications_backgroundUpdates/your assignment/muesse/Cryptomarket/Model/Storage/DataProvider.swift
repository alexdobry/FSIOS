//
//  DataProvider.swift
//  Cryptomarket
//
//  Created by Alex on 12.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum ModelSource {
    case database, network, both
}

protocol DataProvider {
    associatedtype Model
    
    func model(from source: ModelSource, completion: @escaping (Result<[Model]>) -> Void)
}
