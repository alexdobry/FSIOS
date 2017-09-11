//
//  MessageManager.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 31.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

protocol MessageManagerDelegate : class {
    func receivedItem(_ itemName: String, from peer: MCPeerID)
    func receivedImage(_ image: UIImage, from peer: MCPeerID)
    func receivedStartGame()
    func receivedLostGame(from peer: MCPeerID)
    func receivedPauseGame()
    func receivedResumeGame()
    func receivedChangedTime(_ by: Double, from peer: MCPeerID)
    func receivedSwitchScreen()
    func receivedReadyToPlay(from peer: MCPeerID, _ isReady: Bool)
    func receivedRestart()
    func receivedLeftGame(from peer: MCPeerID)
    func receivedJoinedGame(from peer: MCPeerID)
    func receivedGotKicked()
}

extension MessageManagerDelegate {
    func receivedItem(_ itemName: String, from peer: MCPeerID){}
    func receivedImage(_ image: UIImage, from peer: MCPeerID){}
    func receivedStartGame(){}
    func receivedLostGame(from peer: MCPeerID){}
    func receivedPauseGame(){}
    func receivedResumeGame(){}
    func receivedChangedTime(_ by: Double, from peer: MCPeerID){}
    func receivedSwitchScreen(){}
    func receivedReadyToPlay(from peer: MCPeerID, _ isReady: Bool){}
    func receivedRestart(){}
    func receivedLeftGame(from peer: MCPeerID){}
    func receivedJoinedGame(from peer: MCPeerID){}
    func receivedGotKicked() {}
}

struct MessageManager {
    weak var delegate: MessageManagerDelegate?
    
    func buildInviteMessage(password pw: String? = nil) -> Data {
        var message = [String: Any]()
        if pw != nil {message[MessageType.password.rawValue] = pw}
        return convertToData(message: message)
    }
    
    func reconstructInviteMessage(dataMessage data: Data) -> [String: Any]{
        let dictionary: Dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: Any]
        return dictionary
    }
    
    func buildMessage(with type: MessageType, value: Any) -> Data {
        let message : [String: Any] = [type.rawValue: value]
        return convertToData(message: message)
    }

    private func convertToData(message: [String: Any]) -> Data {
        let dataMessage: Data = NSKeyedArchiver.archivedData(withRootObject: message)
        return dataMessage
    }
    
    func reconstructMessage(from peer: MCPeerID, dataMessage data: Data) {
        let dictionary: Dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: Any]
        identifyMessage(from: peer, message: dictionary)
    }
    
    private func identifyMessage(from peer: MCPeerID, message: [String: Any]) {
        switch Array(message.keys).first! {
            case MessageType.item.rawValue :
                delegate?.receivedItem(message.values.first as! String, from: peer)
                break
            
            case MessageType.image.rawValue :
                delegate?.receivedImage(message.values.first as! UIImage, from: peer)
                break
            
            case MessageType.startGame.rawValue :
                delegate?.receivedStartGame()
                break
            
            case MessageType.lostGame.rawValue :
                delegate?.receivedLostGame(from: peer)
                break
            
            case MessageType.pauseGame.rawValue :
                delegate?.receivedPauseGame()
                break
            
            case MessageType.resumeGame.rawValue :
                delegate?.receivedResumeGame()
                break
            
            case MessageType.changedTime.rawValue :
                delegate?.receivedChangedTime(message.values.first as! Double, from: peer)
                break
            
            case MessageType.switchScreen.rawValue :
                delegate?.receivedSwitchScreen()
                break
            
            case MessageType.readyToPlay.rawValue :
                delegate?.receivedReadyToPlay(from: peer, message.values.first as! Bool)
                break
            
            case MessageType.restart.rawValue :
                delegate?.receivedRestart()
                break
            
            case MessageType.leftGame.rawValue :
                delegate?.receivedLeftGame(from: peer)
                break
            
            case MessageType.joinedGame.rawValue :
                delegate?.receivedJoinedGame(from: peer)
                break
            
            case MessageType.gotKicked.rawValue :
                delegate?.receivedGotKicked()
                break
            
            default: break
        }
    }
}
