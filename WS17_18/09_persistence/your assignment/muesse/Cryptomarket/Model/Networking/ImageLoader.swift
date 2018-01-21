//
//  ImageLoadewr.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader(
        cache: NSCache()
    )
    
    
    private let cache: NSCache<NSString, UIImage>
    
    private init(cache: NSCache<NSString, UIImage>) {
        self.cache = cache
    }
    
    func imageBy(url: URL) -> UIImage? {
        let data = try? Data(contentsOf: url)
        let image = data.flatMap(UIImage.init)
                
        return image
    }
    
    func imageBy(url: URL, completion: @escaping (UIImage?, URL) -> Void) {
        if let cached = get(url.absoluteString) {
            debugPrint(#function, "from cache")
            completion(cached, url)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                debugPrint(#function, "from web")
                let data = try? Data(contentsOf: url)
                let image = data.flatMap(UIImage.init)
                
                DispatchQueue.main.async {
                    if let img = image {
                        self.set(img, withData: data, for: url.absoluteString)
                        completion(image, url)
                    } else {
                        completion(nil, url)
                    }
                }
            }
        }
    }
    
    private func get(_ key: String) -> UIImage? {
        if let image = cache.object(forKey: NSString(string: key)) {
            debugPrint(#function, "from cache", key)
            return image
        } else {
            guard let baseUrl = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
            let url = baseUrl.appendingPathComponent("\(key.hashValue)")
            if let data = try? Data(contentsOf: url) {
                debugPrint(#function, "from disk", key)
                return UIImage.init(data: data)
            } else {
                debugPrint(#function, "noData", key)
                return nil
            }
        }
    }
    
    private func set(_ img: UIImage, withData data: Data?, for key: String) {
        cache.setObject(img, forKey: NSString(string: key))
        
        guard let baseUrl = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return }
        let url = baseUrl.appendingPathComponent("\(key.hashValue)")
        try? data?.write(to: url)
    }
}
