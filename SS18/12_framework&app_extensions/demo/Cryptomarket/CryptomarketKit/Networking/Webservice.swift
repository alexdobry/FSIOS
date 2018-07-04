//
//  Webservice.swift
//  Cryptomarket
//
//  Created by Alex on 13.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public struct Ressource<T> {
    let url: URL
    let parse: (Data) throws -> T
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public class Webservice {
    
    public func request<T>(_ ressource: Ressource<T>, completion: @escaping (Result<T>) -> Void, timeout: TimeInterval = 5.0) {
        let request = URLRequest(url: ressource.url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)
        
        let task = URLSession.shared.dataTask(with: request) { (data, reponse, webError) in
            let result: Result<T>
            
            if let data = data {
                do {
                    let json = try ressource.parse(data)
                    result = .success(json)
                } catch {
                    result = .failure(error)
                }
            } else {
                result = .failure(webError!)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        task.resume() // fire request
    }
}
