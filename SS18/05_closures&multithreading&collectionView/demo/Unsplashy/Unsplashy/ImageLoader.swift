//
//  ImageLoader.swift
//  Unsplashy
//
//  Created by Alex on 09.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

final class ImageLoader {
    
    static let `default` = ImageLoader()
    
    private init() {}
    
    func imageBy(url: URL) -> UIImage? { // sync
        let data = try? Data(contentsOf: url)
        return data.flatMap(UIImage.init)
    }
    
    // performed async. completion is called on main thread
    func imageBy2(url: URL, completion: @escaping (UIImage?) -> Void) { // async
        DispatchQueue.global(qos: .userInitiated).async {
            // off main thread
            
            let data = try? Data(contentsOf: url)
            let image = data.flatMap(UIImage.init)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
