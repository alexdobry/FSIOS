//
//  Tag.swift
//  Yatodoa
//
//  Created by Alex on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

struct Tag {
    let title: String
    let color: UIColor
    
    private init(title: String, color: UIColor) {
        self.title = title
        self.color = color
    }
    
    init(title: String) {
        self.init(title: title, color: UIColor.random)
    }
    
    static func from(title: String) -> Tag? {
        return all.first(where: { $0.title == title })
    }
    
    static let empty = Tag(title: "")
    
    static var all = [Tag(title: "general"), Tag(title: "shopping list"), Tag(title: "study"), Tag(title: "work")]
}
