//
//  Theme.swift
//  Yatodoa
//
//  Created by Alex on 25.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum Theme {
    case standard, colorful
    
    var title: String {
        switch self {
        case .standard: return "Standard"
        case .colorful: return "Farbenfroh"
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .standard: return #colorLiteral(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        case .colorful: return .yatodoaBrown
        }
    }
    
    var navigationBarBackgroundColor: UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .yatodoaBrown
        }
    }
    
    var navigationBarTextColor: UIColor {
        switch self {
        case .standard: return .black
        case .colorful: return .white
        }
    }
    
    var navigationBarTintColor: UIColor {
        switch self {
        case .standard: return tintColor
        case .colorful: return .white
        }
    }
    
    var positiveColor: UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .yatodoaGreen
        }
    }
    
    var labelColor: UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .yatodoaBrown
        }
    }
    
    var secondaryTextColor: UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .yatodoaRed
        }
    }
    
    var checkbox: Checkbox {
        switch self {
        case .standard: return Checkbox(checkmarkColor: .black, borderColor: nil)
        case .colorful: return Checkbox(checkmarkColor: .yatodoaGreen, borderColor: .yatodoaGreen)
        }
    }
    
    static let all: [Theme] = [.standard, .colorful]
}

class ThemeManager {
    static var current: Theme = .standard {
        didSet { apply(current) }
    }
    
    private init() { }
    
    private static func apply(_ theme: Theme) {
        // global tint
        UIApplication.shared.delegate?.window??.tintColor = theme.tintColor
        
        // navigation
        let textAttributes = [NSAttributedStringKey.foregroundColor: theme.navigationBarTextColor]
        
        UINavigationBar.appearance().barTintColor = theme.navigationBarBackgroundColor
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().tintColor = theme.navigationBarTintColor
        
        // switch
        UISwitch.appearance().onTintColor = theme.positiveColor?.withAlphaComponent(0.5)
        UISwitch.appearance().thumbTintColor = theme.positiveColor
        
        // header footer view
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, DetailTodoTableViewController.self]).textColor = theme.labelColor
        
        // checkbox
        TDCheckbox.appearance().checkbox = theme.checkbox
        
        // AddTodoView
        UIButton.appearance(whenContainedInInstancesOf: [AddTodoView.self]).setTitleColor(theme.positiveColor, for: .normal)
        
        // TodoCell
        UILabel.appearance(whenContainedInInstancesOf: [TodoTableViewCell.self]).textColor = theme.secondaryTextColor
    }
}
