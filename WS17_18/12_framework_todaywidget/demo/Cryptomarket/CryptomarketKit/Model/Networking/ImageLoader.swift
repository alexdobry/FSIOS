//
//  ImageLoadewr.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

func measure(f: () -> Void) {
    let start = Date().timeIntervalSince1970
    f()
    let end = Date().timeIntervalSince1970 - start
    
    debugPrint(#function, String(format: "%.4f s", end))
}

public final class ImageLoader {
    
    public static let shared = ImageLoader(
        cache: NSCache(),
        url: try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    )
    
    private let cache: NSCache<NSString, UIImage>
    private let url: URL?
    
    private init(cache: NSCache<NSString, UIImage>, url: URL?) {
        self.cache = cache
        self.url = url
    }
    
    public func imageBy(url: URL) -> UIImage? {
        let data = try? Data(contentsOf: url)
        let image = data.flatMap(UIImage.init)
        
        return image
    }
    
    public func imageBy(url: URL, completion: @escaping (UIImage?, URL) -> Void) {
        if let cached = get(url.absoluteString) {
            completion(cached, url)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: url)
                let image = data.flatMap(UIImage.init)
                
                DispatchQueue.main.async {
                    if let img = image {
                        self.set(img, of: data!, for: url.absoluteString)
                        completion(image, url)
                    } else {
                        completion(nil, url)
                    }
                }
            }
        }
    }
    
    private func fileUrl(from key: String) -> URL? {
        return url?.appendingPathComponent(String(key.hashValue))
    }
    
    private func get(_ key: String) -> UIImage? {
        if let cached = cache.object(forKey: NSString(string: key)) {
            debugPrint(#function, "from cache", key)
            return cached
        }
        
        if let fileUrl = fileUrl(from: key), FileManager.default.fileExists(atPath: fileUrl.path) {
            debugPrint(#function, "from disk", key)
            return imageBy(url: fileUrl)
        } else {
            debugPrint(#function, "nil", key)
            return nil
        }
    }
    
    private func set(_ img: UIImage, of data: Data, for key: String) {
        cache.setObject(img, forKey: NSString(string: key))
        debugPrint(#function, "to cache", key)
        
        if let url = fileUrl(from: key), let _ = try? data.write(to: url) {
            debugPrint(#function, "to disk", key)
        } else {
            debugPrint(#function, "nil", key)
        }
    }
}
