//
//  Database.swift
//  Cryptomarket
//
//  Created by Alex on 16.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

protocol UniqueEntity { }

protocol Database {
    func getAll<Model: UniqueEntity>() -> [Model]
    func insert<Model: UniqueEntity>(_ model: Model) -> [Model]
    func override<Model: UniqueEntity>(_ models: [Model])
}
