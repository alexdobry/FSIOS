//
//  MPCManager.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 31.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol MultipeerSessionManagerDelegate : class {
    func userJoined(user peer: MCPeerID)
    func userLeft(user peer: MCPeerID)
}

protocol MultipeerBrowseManagerDelegate : class {
    func foundPeer()
    func lostPeer()
    func failedBrowsing()
}

class MPCManager: NSObject {
    var messageManager = MessageManager()
    var maxMember = 1
    
    //for session
    let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    var session : MCSession!
    
    weak var sessionDelegate : MultipeerSessionManagerDelegate?
    
    //for advertiser
    var advertiser : MCNearbyServiceAdvertiser?
    
    var password : String?
        
    //for browser
    var foundPeers = [(peer: MCPeerID, passwordNeeded: Bool)]()
    
    var browser : MCNearbyServiceBrowser?
    
    weak var browseDelegate : MultipeerBrowseManagerDelegate?
    
    override init() {
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
    }
    
    //Mark: Functions for Advertiser
    func startAdvertiser(for game: Game, password pw: String? = nil) {
        if pw != nil {
            if !pw!.isEmpty {
                password = pw
                advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["passwordRequired": "yes"], serviceType: MultipeerServiceType.getMatchingServiceType(for: game).rawValue)
            } else {
                advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: MultipeerServiceType.getMatchingServiceType(for: game).rawValue)
            }
        } else {
            advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: MultipeerServiceType.getMatchingServiceType(for: game).rawValue)
        }
        
        advertiser!.delegate = self
        advertiser!.startAdvertisingPeer()
    }
    
    func restartAdvertising() {
        advertiser?.startAdvertisingPeer()
    }
    
    func stopAdvertiser() {
        advertiser?.stopAdvertisingPeer()
    }
    
    //Mark: Functions for Browser
    func startBrowser(for game: Game) {
        foundPeers.removeAll()
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: MultipeerServiceType.getMatchingServiceType(for: game).rawValue)
        browser!.delegate = self
        browser!.startBrowsingForPeers()
    }
    
    func stopBrowser() {
        browser?.stopBrowsingForPeers()
        browser = nil
    }
    
    func invite(peerIndex index: Int, password pw: String? = nil) {
        let message = messageManager.buildInviteMessage(password: pw)
        browser?.invitePeer(foundPeers[index].peer, to: session, withContext: message, timeout: 10)
        stopBrowser()
    }
    
    func sendData(messageType type: MessageType, messageValue value: Any, toPeers peers: [MCPeerID]) {
        do {
            let dataMessage = messageManager.buildMessage(with: type, value: value)
            try session.send(dataMessage, toPeers: peers, with: .reliable)
        }
        catch let error {
            print(error)
        }
    }
    
    func shutDown() {
        browseDelegate = nil
        sessionDelegate = nil
        stopAdvertiser()
        stopBrowser()
        session.disconnect()
        foundPeers.removeAll()
    }
}

extension MPCManager : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            sessionDelegate?.userJoined(user: peerID)
            
            break
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            print(UIDevice.current.name)
            break
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            sessionDelegate?.userLeft(user: peerID)
            
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        messageManager.reconstructMessage(from: peerID, dataMessage: data)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
}

extension MPCManager : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        if let ct = context {
            let message = messageManager.reconstructInviteMessage(dataMessage: ct)
            if let peerPassword = message[MessageType.password.rawValue] as? String {
                if peerPassword == password {
                    invitationHandler(true, session)
                }
                else {invitationHandler(false, nil)}
            } else {
                invitationHandler(true, session)
            }
        } else {
            invitationHandler(true, session)
        }
    }
}

extension MPCManager : MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if !foundPeers.contains {$0.peer.description == peerID.description} {
            var pwNeeded = false
            if let information = info {
                if information["passwordRequired"] != nil {pwNeeded = true}
            }
            
            foundPeers.append((peer: peerID, passwordNeeded: pwNeeded))
            browseDelegate?.foundPeer()
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated(){
            if aPeer.peer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        browseDelegate?.lostPeer()
    }
}
