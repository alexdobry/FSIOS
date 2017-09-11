//
//  MultipeerBrowserViewController.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 30.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultipeerBrowserViewController: UIViewController {
    @IBOutlet weak var peerTable: UITableView!
    @IBOutlet weak var header: UINavigationItem!
    
    var game : Game = Game(gameName: "Giant Wars", imageName: "String", gameType: .multi, description: "String")
    var mpcManager : MPCManager!
    var inviteActive = false
    var myPicture : UIImage!
    var leader : MCPeerID?
    var viewDidAppear = false
    
    let images = [#imageLiteral(resourceName: "doener"), #imageLiteral(resourceName: "eddy")]
    let colors : [UIColor] = [.cyan, .orange, .green, .yellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rndImage = images[Int(arc4random_uniform(UInt32(images.count)))]
        let rndColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        myPicture = ProfileImageMaker.imageMaker.createProfileImage(from: rndImage, favoriteColor: rndColor, radius: view.frame.height / 20)

        peerTable.delegate = self
        peerTable.dataSource = self
        
        let headerBorder : CGFloat = 4.0
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 10))
        headerView.backgroundColor = peerTable.sectionIndexBackgroundColor
        
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
        
        let label: UILabel = UILabel.init(frame: headerView.frame)
        label.text = "Searching for: \(game.name)"
        label.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 16.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        
        headerView.addSubview(label)
        peerTable.tableHeaderView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mpcManager = MPCManager()
        mpcManager.browseDelegate = self
        mpcManager.sessionDelegate = self
        mpcManager.startBrowser(for: game)
        viewDidAppear = true
        peerTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberLobbySegue" {
            if let toViewController = segue.destination as? MultipeerLobbyViewController {
                mpcManager.sessionDelegate = nil
                mpcManager.browseDelegate = nil
                
                for userPeer in mpcManager.session.connectedPeers {
                    toViewController.profileImages[userPeer.description] = #imageLiteral(resourceName: "profileUnknown")
                }
                toViewController.game = game
                toViewController.leader = leader
                toViewController.myPicture = myPicture
                toViewController.mpcManager = self.mpcManager
            }
        }
    }
 
    
}

extension MultipeerBrowserViewController : MultipeerBrowseManagerDelegate {
    func foundPeer() {
        peerTable.reloadData()
    }
    
    func lostPeer() {
        peerTable.reloadData()
    }
    
    func failedBrowsing() {
        
    }
}

extension MultipeerBrowserViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  viewDidAppear { return mpcManager.foundPeers.count }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = peerTable.dequeueReusableCell(withIdentifier: "MultipeerBrowserCell", for: indexPath) as? MultipeerBrowserCell else {fatalError("table row geht nicht")}
        
        let peerName = mpcManager.foundPeers[indexPath.row].peer.displayName
        
        cell.peerName.text = peerName
        cell.peerImage.backgroundColor = .clear
        
        if mpcManager.foundPeers[indexPath.row].passwordNeeded {
            cell.peerImage.image = #imageLiteral(resourceName: "lock")
        } else {
            cell.peerImage.image = #imageLiteral(resourceName: "unlock")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row

        if mpcManager.foundPeers[index].passwordNeeded {
            let alertController = UIAlertController(title: "Enter the password.", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Enter Room", style: .default, handler: {
                alert -> Void in
                
                let passwordField = alertController.textFields![0] as UITextField
                
                guard let text = passwordField.text else {return}
                if !text.isEmpty {
                    self.inviteActive = true
                    self.mpcManager.invite(peerIndex: index, password: text)
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Password"
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            inviteActive = true
            mpcManager.invite(peerIndex: index)
        }
    }
}

extension MultipeerBrowserViewController : MultipeerSessionManagerDelegate {
    func userJoined(user peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            if strongS.mpcManager.browser != nil {strongS.mpcManager.stopBrowser()}
            strongS.inviteActive = false
            strongS.leader = peer
            strongS.performSegue(withIdentifier: "MemberLobbySegue", sender: strongS)
        }
    }
    
    func userLeft(user peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            if strongS.inviteActive {
                strongS.inviteActive = false
                    
                let alertController = UIAlertController(title: "Invite has been declined.", message: "Your invitation has been declined. Maybe you entered a wrong password.", preferredStyle: .alert)
                    
                let closeAction = UIAlertAction(title: "Close", style: .default, handler: {
                        (action : UIAlertAction!) -> Void in
                    strongS.mpcManager.startBrowser(for: strongS.game)
                })
                    
                alertController.addAction(closeAction)
                strongS.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
