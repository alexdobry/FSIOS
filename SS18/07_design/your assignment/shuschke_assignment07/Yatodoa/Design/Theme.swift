//
//  Theme.swift
//  Yatodoa
//
//  Created by Alex on 30.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum Theme {
    case standard, colorful, dark
    
    var title: String {
        switch self {
        case .colorful: return "Farbenfroh"
        case .standard: return "Standard"
        case .dark: return "Dark"
        }
    }
    
    static let all: [Theme] = [standard, colorful, dark]
}
