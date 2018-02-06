//
//  Result.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
    
    public func map<U>(transform: (T) -> U) -> Result<U> {
        switch self {
        case .success(let s): return .success(transform(s))
        case .failure(let e): return .failure(e)
        }
    }
    
    public func mapOrNil<U>(_ transform: (T) -> U?) -> U? {
        switch self {
        case .success(let s): return transform(s) ?? nil
        case .failure: return nil
        }
    }
}
