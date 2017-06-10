//
//  Items.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 10.06.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import Foundation

struct item {
    private let name : String
    private let image : String
    private let action : () -> Void
    
    func getName() -> String {
        return name
    }
    
    func getImage() -> String {
        return image
    }
}


