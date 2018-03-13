//
//  Database.swift
//  Cryptomarket
//
//  Created by Alex on 08.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

protocol UniqueEntitiy { }

typealias Database = ReadableDatabase & WriteableDatabase

protocol ReadableDatabase {
    func getAll<Model: UniqueEntitiy>() -> [Model]
}

protocol WriteableDatabase {
    func insert<Model: UniqueEntitiy>(_ model: Model) -> [Model]
    func override<Model: UniqueEntitiy>(with models: [Model])
}
