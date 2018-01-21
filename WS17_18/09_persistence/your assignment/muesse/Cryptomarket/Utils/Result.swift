//
//  Result.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
    
//    func map<U>(transform: (T) -> U) -> Result<U> {
//        switch self {
//        case .success(let t): return .success(transform(t))
//        case .failure(let e): return .failure(e)
//        }
//    }
    
//    var value: T? {
//        switch self {
//        case .success(let t): return t
//        case .failure: return nil
//        }
//    }
}
