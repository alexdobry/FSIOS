//
//  Result.swift
//  Cryptomarket
//
//  Created by Alex on 09.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
