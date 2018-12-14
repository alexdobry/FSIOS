//
//  ImageLoader.swift
//  Cryptomarket
//
//  Created by Alex on 13.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init() { }
    
    func image(by url: URL, completion: @escaping (UIImage?, URL) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = try? Data.init(contentsOf: url) // blockt
            let img = data.flatMap(UIImage.init)
            
            DispatchQueue.main.async {
                completion(img, url)
            }
        }
    }
}
