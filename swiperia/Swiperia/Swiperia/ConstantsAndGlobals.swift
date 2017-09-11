//
//  Constants.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 16.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SpriteKit

struct Constants {
    static let ITEM_SHOW_TIME : Double = 0.5
    static let ITEM_MANIFEST_TIME : Double = 0.5
    static let ITEM_DISAPPEAR_TIME : Double = 0.5
    static let ITEM_MOVE_TIME : Double = 1.0

    static let ROBOT_MAX_TIME: Double = 10.0
    
    static let LEVEL_CHANGE_MULTIPLICATOR : Double = 1.5
    static let MULTIPLICATOR_STEPS : [Double] = [1.1, 1.2, 1.3, 1.5, 1.8, 2.3]
    
    static let SPRITEKIT_MINIMIZE_FACTOR : CGFloat = 3.1
    
    static let BACKGROUND_LIGHT_TYPE = 2
    static let SPHERE_LIGHT_TYPE = 3
    
    static let pauseNotification = "pauseNotification"
    static let resumeNotification = "resumeNotification"
}
