//
//  MultipeerAdvertiserViewController.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 29.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultipeerLobbyViewController: UIViewController {
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var groupTable: UITableView!
    
    var mpcManager : MPCManager!
    var game : Game!
    var memberReady : [String] = []
    var maxMember = 1
    var password : String?
    var isHost = false
    var leader : MCPeerID!
    var viewDidAppear = false
    
    var profileImages = [String: UIImage]() {
        didSet {
            if viewDidAppear {
                groupTable.reloadData()
            }
        }
    }
    
    var buttonColor : UIColor?
    var myPicture : UIImage!
    
    let images = [#imageLiteral(resourceName: "doener"), #imageLiteral(resourceName: "eddy")]
    let colors : [UIColor] = [.cyan, .orange, .green, .yellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rndImage = images[Int(arc4random_uniform(UInt32(images.count)))]
        let rndColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]

        buttonColor = startButton.backgroundColor
        startButton.backgroundColor = .clear
        if isHost {
            mpcManager = MPCManager()
            leader = mpcManager.myPeerID
            //mpcManager.maxMember = maxMember
            myPicture = ProfileImageMaker.imageMaker.createProfileImage(from: rndImage, favoriteColor: rndColor, radius: view.frame.height / 20)
            startButton.setTitleColor(.darkGray, for: .disabled)
            startButton.setTitle("Waiting...", for: .disabled)
            startButton.setBackgroundImage(#imageLiteral(resourceName: "highButtonBlack"), for: .normal)
            startButton.setBackgroundImage(#imageLiteral(resourceName: "highButtonGray"), for: .disabled)
            startButton.isEnabled = false
        } else {
            startButton.setTitle("Im Ready", for: .normal)
            startButton.setBackgroundImage(#imageLiteral(resourceName: "highButtonBlack"), for: .normal)
        }

        groupTable.delegate = self
        groupTable.dataSource = self
        
        let headerBorder : CGFloat = 4.0
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 10))
        
        let topLayer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerBorder))
        topLayer.backgroundColor = UIColor.white
        
        let botLayer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerBorder))
        botLayer.backgroundColor = UIColor.white

        headerView.addSubview(topLayer)
        headerView.addSubview(botLayer)
        headerView.layer.borderWidth = 0
        
        topLayer.frame.origin.x = 0
        topLayer.frame.origin.y = 0
        botLayer.frame.origin.x = 0
        botLayer.frame.origin.y = headerView.frame.height - botLayer.frame.height
        
        headerView.backgroundColor = buttonColor
        let label: UILabel = UILabel.init(frame: headerView.frame)
        label.text = "Your Group"
        label.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 16.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        
        headerView.addSubview(label)
        groupTable.tableHeaderView = headerView
        startButton.addTarget(self, action: #selector(executeButtonAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isHost && mpcManager.session.connectedPeers.count == 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            if isHost {
                mpcManager.startAdvertiser(for: game, password: password)
                startButton.isEnabled = false
            } else {
                startButton.setTitle("Im Ready", for: .normal)
                startButton.setBackgroundImage(#imageLiteral(resourceName: "highButtonBlack"), for: .normal)
            }
        
            removeUnnecessaryImages()
            
            memberReady.removeAll()
        
            mpcManager.sessionDelegate = self
            mpcManager.messageManager.delegate = self
        
            mpcManager.sendData(messageType: .image, messageValue: myPicture, toPeers: mpcManager.session.connectedPeers)
        
            mpcManager.sendData(messageType: .joinedGame, messageValue: "", toPeers: mpcManager.session.connectedPeers)
        
            profileImages[mpcManager.myPeerID.description] = myPicture
        
            viewDidAppear = true
        
            groupTable.reloadData()
        }
    }
    
    private func removeUnnecessaryImages() {
        var tempImages = [String: UIImage]()
        for userPeer in mpcManager.session.connectedPeers {
            let temp = profileImages[userPeer.description]
            if temp != nil { tempImages[userPeer.description] = temp }
        }
        profileImages = tempImages
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func executeButtonAction(_ button: UIButton) {
        guard let buttonText = button.titleLabel?.text else {return}
        switch buttonText{

            case "Im Ready":
                mpcManager.sendData(messageType: .readyToPlay, messageValue: true, toPeers: mpcManager.session.connectedPeers)
                startButton.setTitle("Not Ready", for: .normal)
                startButton.setBackgroundImage(#imageLiteral(resourceName: "highButtonRed"), for: .normal)
                
                if !memberReady.contains(mpcManager.myPeerID.description) {
                    memberReady.append(mpcManager.myPeerID.description)
                }
                
                groupTable.reloadData()
                break
            
            case "Not Ready":
                mpcManager.sendData(messageType: .readyToPlay, messageValue: false, toPeers: mpcManager.session.connectedPeers)
                startButton.setTitle("Im Ready", for: .normal)
                startButton.setBackgroundImage(#imageLiteral(resourceName: "highButtonBlack"), for: .normal)
                
                if let index = memberReady.index(of: mpcManager.myPeerID.description) {
                    memberReady.remove(at: index)
                }
                
                groupTable.reloadData()
                break
            
            case "Start Game":
                mpcManager.sendData(messageType: .switchScreen, messageValue: "", toPeers: mpcManager.session.connectedPeers)
                performSegue(withIdentifier: game.name, sender: self)
                break
            
        default:
            break
        }
    }
    
    func checkButton() {
        if isHost {
            if memberReady.count == mpcManager.session.connectedPeers.count && memberReady.count > 0 {
                startButton.isEnabled = true
            }
            else {
                startButton.isEnabled = false
            }
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            viewDidAppear = false
            mpcManager.shutDown()
            profileImages.removeAll()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == game.name {
            mpcManager.stopAdvertiser()
            if let toViewController = segue.destination as? GiantWarsController {
                toViewController.mpcManager = self.mpcManager
                if isHost { toViewController.isHost = true }
                let opponent = mpcManager.session.connectedPeers[0]
                let opponentImage = profileImages[opponent.description]!
                toViewController.opponent = (peer: opponent, image: opponentImage)
                toViewController.leader = leader
                mpcManager.messageManager.delegate = toViewController
                mpcManager.sessionDelegate = toViewController
                mpcManager.browseDelegate = nil
            }
        }
    }
}

extension MultipeerLobbyViewController : MultipeerSessionManagerDelegate {
    func userJoined(user peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.profileImages[peer.description] = #imageLiteral(resourceName: "profileUnknown")
            strongS.groupTable.reloadData()
        }
    }
    
    func userLeft(user peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            if (strongS.mpcManager.session.connectedPeers.count <= 0 || peer == strongS.leader) && !strongS.isHost {
                strongS.navigationController?.popViewController(animated: true)
            } else {
                strongS.profileImages.removeValue(forKey: peer.description)
                if strongS.mpcManager.session.connectedPeers.count < strongS.maxMember && strongS.isHost {
                    if strongS.mpcManager.advertiser != nil {strongS.mpcManager.restartAdvertising()}
                }
            
                if let index = strongS.memberReady.index(of: peer.description) {
                    strongS.memberReady.remove(at: index)
                }
            
                strongS.checkButton()
                strongS.groupTable.reloadData()
            }
        }
    }
}

extension MultipeerLobbyViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewDidAppear {
            return mpcManager.session.connectedPeers.count + 1
        }else {return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupTable.dequeueReusableCell(withIdentifier: "MultipeerAdvertiserCell", for: indexPath as IndexPath) as? MultipeerAdvertiserCell else {fatalError("table row geht nicht")}
        
        var peer : MCPeerID
        
        cell.checkImage.backgroundColor = .clear
        
        if indexPath.row == 0 {
            peer = mpcManager.myPeerID
        } else {
            peer = mpcManager.session.connectedPeers[indexPath.row - 1] 
        }
        
        if peer.description == leader.description { cell.checkImage.image = #imageLiteral(resourceName: "crown") }
        else if memberReady.contains(peer.description) {
            cell.checkImage.image = #imageLiteral(resourceName: "check")
        } else { cell.checkImage.image = nil }
        
        cell.peerName.text = peer.displayName
        
        cell.peerImage.image = profileImages[peer.description]!
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if isHost && index != 0 {
            let alertController = UIAlertController(title: "Remove Player.", message: "Do you really want to remove \(mpcManager.session.connectedPeers[index - 1].displayName) from the your lobby ?", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Yes", style: .default, handler: {
                alert -> Void in
                
                self.mpcManager.sendData(messageType: .gotKicked, messageValue: "", toPeers: [self.mpcManager.session.connectedPeers[index - 1]])
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension MultipeerLobbyViewController : MessageManagerDelegate {
    func receivedReadyToPlay(from peer: MCPeerID, _ isReady: Bool) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            if isReady { strongS.memberReady.append(peer.description) }
            else {
                guard let index = strongS.memberReady.index(of: peer.description) else {return}
                strongS.memberReady.remove(at: index)
            }
        
            strongS.checkButton()
            strongS.groupTable.reloadData()
        }
    }
    
    func receivedSwitchScreen() {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.performSegue(withIdentifier: strongS.game.name, sender: strongS)
        }
    }
    
    func receivedImage(_ image: UIImage, from peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.profileImages[peer.description] = image
        }
    }
    
    func receivedJoinedGame(from peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.mpcManager.sendData(messageType: .image, messageValue: strongS.myPicture, toPeers: [peer])
        }
    }
    
    func receivedGotKicked() {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.navigationController?.popViewController(animated: true)
        }
    }
}
