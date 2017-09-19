//
//  CollapsableViewModel.swift
//  Swiperia
//
//  Created by Edgar Gellert on 14.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation

class CollapseableViewModel {
    let label : String
    let image : UIImage?
    let children : [CollapseableViewModel]
    var isCollapsed : Bool
    var needsSeperator : Bool = true
    
    init(label : String, image : UIImage? = nil, children : [CollapseableViewModel] = [], isCollapsed : Bool = true) {
        self.label = label
        self.image = image
        self.children = children
        self.isCollapsed = isCollapsed
        
        for child in self.children {
            child.needsSeperator = false
        }
        self.children.last?.needsSeperator = true
    }
}
