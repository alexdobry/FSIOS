//
//  TagType.swift
//  Yatodoa
//
//  Created by Alex on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum TagType {
    case add, list
    
    init(by tag: Tag) {
        self = tag.title.isEmpty ? .add : .list
    }
    
    var headerTitle: String {
        switch self {
        case .add: return "Neuen Tag hinzufügen"
        case .list: return "Tags"
        }
    }
    
    static func < (lhs: TagType, rhs: TagType) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
}
