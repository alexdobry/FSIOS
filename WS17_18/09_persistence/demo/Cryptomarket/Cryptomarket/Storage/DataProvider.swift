//
//  DataProvider.swift
//  Cryptomarket
//
//  Created by Alex on 16.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum Source {
    case network, database, both
}

protocol DataProvider {
    associatedtype Model
    
    func model(from source: Source, completion: @escaping (Result<[Model]>) -> Void)
}
