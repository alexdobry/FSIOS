//
//  MultipeerManager.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 28.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum MultipeerServiceType : String {
    case giantWars          = "swp-GiantWars"
    case sequenceBreaker    = "swp-SequenceB"
    
    static let allServiceTypes = [giantWars]
    
    static func random() -> MultipeerServiceType {
        return allServiceTypes[Int(arc4random_uniform(UInt32(allServiceTypes.count)))]
    }
    
    static func == (lhs: MultipeerServiceType, rhs: MultipeerServiceType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension MultipeerServiceType : Equatable {
    static func getMatchingServiceType(for game: Game) -> MultipeerServiceType {
        switch game.name {
            case "Giant Wars":
                return .giantWars
                break
            
            case "Sequence Breaker" :
                return .sequenceBreaker
                break
            
            default:
                return .giantWars
                break
        }
    }
}

enum MessageType : String {
    case item           = "item"
    case image          = "image"
    case password       = "password"
    case startGame      = "startGame"
    case lostGame       = "lostGame"
    case pauseGame      = "pauseGame"
    case resumeGame     = "resumeGame"
    case changedTime    = "changedTime"
    case switchScreen   = "switchScreen"
    case readyToPlay    = "readyToPlay"
    case restart        = "restart"
    case leftGame       = "leftGame"
    case joinedGame     = "joinedGame"
    case gotKicked      = "gotKicked"
    
    static let allMessageTypes = [item, image, startGame, lostGame, pauseGame, resumeGame, changedTime, switchScreen, readyToPlay, restart, leftGame, joinedGame, gotKicked]
    
    static func random() -> MessageType {
        return allMessageTypes[Int(arc4random_uniform(UInt32(allMessageTypes.count)))]
    }
}

extension MessageType : Equatable {
    static func == (lhs: MessageType, rhs: MessageType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
