//
//  Theme.swift
//  Yatodoa
//
//  Created by Alex on 05.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit

enum Theme {
    case standard, colorful, dark
    
    var title: String {
        switch self {
        case .standard: return "Standard"
        case .colorful: return "Farbenfroh"
        case .dark: return "Dark Mode"
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .standard: return #colorLiteral(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        case .colorful: return .white
        case .dark: return .yatodoaMediumGrey
        }
    }
    
    var navigationBarBackgroundColor: UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .yatodoaBrown
        case .dark: return .yatodoaDarkBack
        }
    }
    
    var navigationBarTextColor: UIColor {
        switch self {
        case .standard: return .black
        case .colorful: return .white
        case .dark: return .yatodoaLightGrey
        }
    }
    
    var navigationBarTintColor: UIColor {
        switch self {
        case .standard: return tintColor
        case .colorful: return .white
        case .dark: return .yatodoaLightGrey
        }
    }
    
    var switchTintColor: UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .yatodoaGreen
        case .dark: return .yatodoaHighlightColor
        }
    }
    
    var labelTextColor: UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .white
        case .dark: return .yatodoaMediumGrey
        }
    }
    
    var checkbox: Checkbox {
        switch self {
        case .standard: return Checkbox(checkmarkColor: .black, borderColor: nil)
        case .colorful: return Checkbox(checkmarkColor: .yatodoaGreen, borderColor: .yatodoaGreen)
        case .dark: return Checkbox(checkmarkColor: .yatodoaHighlightColor, borderColor: .yatodoaHighlightColor)
        }
    }
    
    var cellBackgroundColor : UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .yatodoaBrown
        case .dark: return .yatodoaDarkBack
        }
    }
    
    var cellLabelColor : UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .white
        case .dark: return .yatodoaLightGrey
        }
    }
    
    var backgroundColor : UIColor? {
        switch self {
        case .standard: return nil
        case .colorful: return .yatodoaBrown
        case .dark: return .yatodoaDarkBack
        }
    }
    
    static let all: [Theme] = [.standard, .colorful, .dark]
}

class ThemeManager {
    static var current: Theme = .standard {
        didSet {
            apply(current)
        }
    }
    
    private init() { }
    
    private static func apply(_ theme: Theme) {
        // global tint
        UIApplication.shared.delegate?.window??.tintColor = theme.tintColor
        // UIApplication.shared.delegate?.window??.backgroundColor = theme.backgroundColor
        
        // navigation
        let textAttributes = [NSAttributedStringKey.foregroundColor: theme.navigationBarTextColor]
        
        UINavigationBar.appearance().barTintColor = theme.navigationBarBackgroundColor
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().tintColor = theme.navigationBarTintColor
        
        // switch
        UISwitch.appearance().onTintColor = theme.switchTintColor?.withAlphaComponent(0.5)
        UISwitch.appearance().thumbTintColor = theme.switchTintColor
        
        // header footer view
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, DetailTodoTableViewController.self]).textColor = theme.labelTextColor
        
        // checkbox
        TDCheckbox.appearance().checkbox = theme.checkbox
        
        
        // UITableView.appearance().backgroundColor = theme.cellBackgroundColor
        UITableViewCell.appearance().backgroundColor = theme.cellBackgroundColor?.withAlphaComponent(0.8)
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = theme.cellLabelColor
        UITextField.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).tintColor = theme.cellLabelColor
    }
}
