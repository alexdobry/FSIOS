//
//  GameViewController.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 02.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit
import MultipeerConnectivity

class GiantWarsController: GameViewController {
    var mpcManager : MPCManager!
    var opponent : (peer: MCPeerID ,image: UIImage)!
    
    var pressedMenue = false
    var toLobby : Bool?
    var isHost = false
    var peersReady = 0
    var wonGames = 0
    var lostGames = 0
    var startGameTimer : TimeManager?
    var winText : BorderTextNode?
    var lostText : BorderTextNode?
    var seperator : BorderTextNode?
    var opponentHealthBar : OpponentHealthBar!
    var leader : MCPeerID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeColor = positiveColor
        
        setupManager()
        setupScene()
        setupSphere()
        setupProgress()
        itemProgressDidChange(to: 0)
        
        //Setup the timers
        gameTimer.delegate = self
        arrowTimer.delegate = self
        gameScore.delegate = self
    }
    
    func setupManager() {
        gameTimer = TimeManager(maxTime: Constants.ROBOT_MAX_TIME, timerName: "gameTimer", maxTimeIntervalForReduction: 0.05)
        arrowTimer = TimeManager(maxTime: 0.8, timerName: "arrowTimer", maxTimeIntervalForReduction: 0.05, true)
        directionManager = StandardDirectionManager()
        gameScore = GameScoreManager(standardScoreIncreaseAmount: 100, standardAmountForLevelChange: 5, itemProgressFinished: 25)
    }
    
    func setupSphere() {
        // Setup the Sphere
        geometryNode = SphereNode(viewSize: self.view.frame.size, positiveColor: positiveColor, negativeColor: negativeColor, firstDirection: directionManager.generateDirection(), orientation: SCNVector4Make(1, 0, 0, -19 * Float((Double.pi) / 180)))
        geometryNode!.position = SCNVector3(0, -0.25, 0)
        geometryNode!.categoryBitMask = Constants.SPHERE_LIGHT_TYPE
        geometryNode.delegate = self
        gameScene.rootNode.addChildNode(geometryNode!)
    }
    
    func setupScene() {
        subView = SCNView.init(frame: gameView.frame)
        gameScene = GolemScene(viewSize: self.view.frame.size, positiveColor: positiveColor)
        
        
        // Setup the SCNView
        subView.scene = gameScene
        subView.allowsCameraControl = false
        overlay = OverlayScene(size: gameView.frame.size, positiveColor: positiveColor, negativeColor: negativeColor, false)
        overlay.overlayDelegate = self
        subView.overlaySKScene = overlay
        
        opponentHealthBar = OpponentHealthBar(frame: CGRect(x: 0, y: 0, width: view.frame.width * (2/3), height: view.frame.height / 15), barWidth: view.frame.height / 30, barColor: opponent.image.areaAverage(), image: opponent.image, maxTime: gameTimer.maxTime)
        subView.addSubview(opponentHealthBar)
        opponentHealthBar.layer.position = CGPoint(x: view.frame.width * 0.99 - opponentHealthBar.frame.width / 2, y: opponentHealthBar.frame.height * 0.75)
        
        gameView.addSubview(subView)
    }
    
    func setupProgress() {
        let width = gameView.frame.size.width
        let height = gameView.frame.size.height
        
        progress = ProgressLayer(radius: width / Constants.SPRITEKIT_MINIMIZE_FACTOR, barWidth: width / 100, barColor: positiveColor)
        progress.position = CGPoint(x: width / 2, y: height - height / 4.95)
        
        let progressSpark = ProgressSpark(radius: width / Constants.SPRITEKIT_MINIMIZE_FACTOR, barWidth: width / 100)
        progressSpark.position = CGPoint(x: width / 2, y: height / 4.95)
        progressSpark.name = "progressSpark"
        
        progress.progressDelegate = progressSpark
        
        overlay.addChild(progressSpark)
        
        subView.layer.addSublayer(progress)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isHost {
            mpcManager.sendData(messageType: .readyToPlay, messageValue: true, toPeers: mpcManager.session.connectedPeers)
        } else {
            if peersReady == mpcManager.session.connectedPeers.count {
                mpcManager.sendData(messageType: .startGame, messageValue: "", toPeers: mpcManager.session.connectedPeers)
                peersReady = 0
                startGame()
            } else {
                startGameTimer = TimeManager(maxTime: 2, timerName: "startGameTimer", maxTimeIntervalForReduction: 2)
                startGameTimer?.delegate = self
                startGameTimer?.startTimer()
            }
        }
    }
    
    override func respondTo(swipeDirection gesture: Direction) {
        super.respondTo(swipeDirection: gesture)
        if stillAlive && geometryNode.clickable && gameTimer.remainingTime >= 0 {
            if !directionManager.compareCurrentDirection(with: gesture) {
                mpcManager.sendData(messageType: .changedTime, messageValue: -1, toPeers: mpcManager.session.connectedPeers)
            }
        }
    }
    
    override func startGame() {
        super.startGame()
        
        //Start the countdown
        particleTimer = TimeManager(maxTime: 4, timerName: "particleTimer", maxTimeIntervalForReduction: 0.05)
        particleTimer!.delegate = self
        particleTimer!.startTimer()
        
        geometryNode.startCountdown(with: 4)
        progress.fillProgress(in: 4)
        
        //Setup Audio
        //MusicPlayer.sharedHelper.playBackgroundMusic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func clearPointsMenue() {
        winText?.removeFromParent()
        winText = nil
        lostText?.removeFromParent()
        lostText = nil
        seperator?.removeFromParent()
        seperator = nil
    }
    
    override func reset() {
        super.reset()
        opponentHealthBar.reset()
    }
    
    override func resume() {
        super.resume()
        clearPointsMenue()
        
        if pressedMenue {
            mpcManager.sendData(messageType: .resumeGame, messageValue: "", toPeers: mpcManager.session.connectedPeers)
            pressedMenue = false
        }
    }
    
    override func restart() {
        clearPointsMenue()
        
        if isHost {
            mpcManager.sendData(messageType: .restart, messageValue: "", toPeers: mpcManager.session.connectedPeers)
        }
        
        super.restart()

        itemProgressDidChange(to: 0)
        
        if !isHost {
            mpcManager.sendData(messageType: .readyToPlay, messageValue: true, toPeers: mpcManager.session.connectedPeers)
        }
    }
    
    override func leaveGame() {
        super.leaveGame()
        //unterschiede machen für isLobby
        //TODO: save all results / do segue
        //TODO: leave game senden
        if toLobby == nil {
            if isHost { toLobby = true }
            else { toLobby = false }
        }
        if toLobby! {
            dismiss(animated: true, completion: nil)
            if isHost { mpcManager.sendData(messageType: .leftGame, messageValue: "", toPeers: mpcManager.session.connectedPeers) }
        }
        else {
            mpcManager.shutDown()
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func showEndscreen(restartButtonVisible visible: Bool) {
        super.showEndscreen(restartButtonVisible: visible)
        
        conButton?.removeFromSuperview()
        conButton = nil
        cancelButton?.removeFromSuperview()
        cancelButton = nil
        
        if visible {
            conButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width / 2.5, height: view.frame.height / 10))
            
            conButton!.layer.cornerRadius = 15
            conButton!.layer.borderWidth = conButton!.frame.height / 15
            conButton!.layer.borderColor = positiveColor.cgColor
            conButton!.setTitle("Restart", for: .normal)
            conButton!.setTitleColor(positiveColor, for: .normal)
            conButton!.backgroundColor = .black
            
            view.addSubview(conButton!)
            conButton!.center = CGPoint(x: view.frame.midX - conButton!.frame.width / 1.5, y: view.frame.midY)
            conButton!.addTarget(self, action: #selector(restart), for: .touchUpInside)
        }
        
        cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width / 2.5, height: view.frame.height / 10))
        
        cancelButton!.layer.cornerRadius = 15
        cancelButton!.layer.borderWidth = cancelButton!.frame.height / 15
        cancelButton!.layer.borderColor = negativeColor.cgColor
        cancelButton!.setTitle("Leave", for: .normal)
        cancelButton!.setTitleColor(negativeColor, for: .normal)
        cancelButton!.backgroundColor = .black
        
        view.addSubview(cancelButton!)
        var position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        
        if visible {
            position = CGPoint(x: view.frame.midX + cancelButton!.frame.width / 1.5, y: view.frame.midY)
        }
        
        cancelButton!.center = position
        cancelButton!.addTarget(self, action: #selector(leaveGame), for: .touchUpInside)
        
        showPointsMenue()
    }
    
    override func showMenue() {
        if !menueActive {
            pressedMenue = true
            showPointsMenue()
            mpcManager.sendData(messageType: .pauseGame, messageValue: "", toPeers: mpcManager.session.connectedPeers)
        }
        
        super.showMenue()
    }
    
    func showPointsMenue() {
        winText = BorderTextNode(text: "\(wonGames)", fontSize: view.frame.height / 7.5, fontColor: .green, fontName: "HelveticaNeue-BoldItalic", borderColor: .clear)
        lostText = BorderTextNode(text: "\(lostGames)", fontSize: view.frame.height / 7.5, fontColor: .red, fontName: "HelveticaNeue-BoldItalic", borderColor: .clear)
        seperator = BorderTextNode(text: "x", fontSize: view.frame.height / 15, fontColor: .white, fontName: "HelveticaNeue-BoldItalic", borderColor: .clear)
        
        overlay.addChild(seperator!)
        seperator?.position = CGPoint(x: view.frame.width / 2 + seperator!.frame.width / 2, y: view.frame.height * (2/3))
        
        overlay.addChild(winText!)
        winText?.position = CGPoint(x: seperator!.position.x - seperator!.frame.width - seperator!.frame.width / 4, y: view.frame.height * (2/3) - winText!.frame.height / 4)
        
        overlay.addChild(lostText!)
        lostText?.position = CGPoint(x: seperator!.position.x + lostText!.frame.width + seperator!.frame.width / 4, y: view.frame.height * (2/3) - lostText!.frame.height / 4)
    }
    
    override func removeAllObjects() {
        super.removeAllObjects()
        
        clearPointsMenue()
        startGameTimer?.stopTimer()
        startGameTimer = nil
    }
}

extension GiantWarsController: TimeManagerDelegate, OverlaySceneDelegate, GameScoreManagerDelegate, SphereNodeDelegate{
    ///TimeManagerDelegate
    func updatedRemainingTime(of name: String, to time: Double) {
        if stillAlive {
            switch name {
            case gameTimer.timerName:
                if time > 0 {
                    let percentage = CGFloat(time / gameTimer.maxTime)
                    progress.progress = percentage
                }
                if time <= 0 {
                    if stillAlive {
                        lostGames += 1
                        progress.progress = 0
                        stillAlive = false
                        geometryNode.gameOverAnimation()
                        showEndscreen(restartButtonVisible: isHost)
                        mpcManager.sendData(messageType: .lostGame, messageValue: "", toPeers: mpcManager.session.connectedPeers)
                    }
                }
        
                break
            
            case arrowTimer.timerName:
                if gameTimer.currentMaxTime > 1 && time <= 0{
                    shakeView()
                    activeColor = negativeColor
                    gameScene.backgroundLight.color = activeColor
                    gameTimer.currentMaxTime -= 1
                    geometryNode.wrongDirection(directionManager.generateDirection(), [gameTimer, arrowTimer])
                    progress.barColor = activeColor
                    gameScore.scored(successfully: false)
                    mpcManager.sendData(messageType: .changedTime, messageValue: -1, toPeers: mpcManager.session.connectedPeers)
                }
            
                break
            
            case "particleTimer" :
                if time >= 0 {
                    let percentage = CGFloat(time / particleTimer!.currentMaxTime)
                    geometryNode.updateParticles(to: percentage)
                    gameScene.backgroundLight.intensity = 1000 * percentage
                    gameScene.sphereLight.color = activeColor.interpolateRGBColorTo(end: UIColor(red: 1, green: 1, blue: 1, alpha: 1), fraction: 1 - percentage)
                }
                
                if time <= 0 {
                    particleTimer!.stopTimer()
                    particleTimer = nil
                }
                
                break
                
            case "startGameTimer":
                if time <= 0{
                    startGameTimer?.stopTimer()
                    if peersReady == mpcManager.session.connectedPeers.count {
                        startGameTimer?.stopTimer()
                        startGameTimer = nil
                        
                        mpcManager.sendData(messageType: .startGame, messageValue: "", toPeers: mpcManager.session.connectedPeers)
                        peersReady = 0
                        startGame()
                    } else {
                        startGameTimer?.resetRemainingTime()
                    }
                }
                
                break
                
            default:
                break
            }
        }
    }
    
    ///SphereNodeDelegate
    func countdownFinished() {
        gameTimer.startTimer()
        arrowTimer.startTimer()
        geometryNode.clickable = true
    }
    
    /// OverlaySceneDelegate
    func ownItemFired(_ item: Item) {
        if stillAlive {
            gameScore.itemChargable = true
            itemProgressDidChange(to: 0)
            mpcManager.sendData(messageType: .item, messageValue: item.name, toPeers: mpcManager.session.connectedPeers)
        }
    }
    
    func opponentItemShown(_ item: Item) {
        geometryNode.resume()
        geometryNode.clickable = true
    }
    
    /// GameScoreManagerDelegate
    func scoreDidChange(to score: Double) {}
    
    func comboLevelDidChange(to level: Int) {
        let percentage = CGFloat(Double(level) / Double(Constants.MULTIPLICATOR_STEPS.count))
        gameScene.comboChanged(to: percentage)
        
        if level >= 2 {
            gameTimer.currentMaxTime += 1
            mpcManager.sendData(messageType: .changedTime, messageValue: 1, toPeers: mpcManager.session.connectedPeers)
        }
    }
    
    func itemProgressDidChange(to progress: Double) {
        let percentage = CGFloat(progress / gameScore.itemProgressFinished)
        geometryNode.updateParticles(to: percentage)
        gameScene.backgroundLight.intensity = 1000 * percentage
        gameScene.sphereLight.color = activeColor.interpolateRGBColorTo(end: UIColor(red: 1, green: 1, blue: 1, alpha: 1), fraction: 1 - percentage)

        if progress <= 0 {
            gameScene.sphereLight.color = UIColor.white
        }
    }
    
    func itemProgressDidFinish() {
        overlay.playerItem = itemManager.randomItem(for: .multi)
    }
}

extension GiantWarsController : MessageManagerDelegate {
    func receivedStartGame() {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.startGame()
        }
    }
    
    func receivedPauseGame() {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.showEndscreen(restartButtonVisible: false)
        }
    }
    
    func receivedResumeGame() {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.resume()
        }
    }
    
    func receivedLostGame(from peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.opponentHealthBar.currentTime = 0
            strongS.wonGames += 1
            strongS.stillAlive = false
            strongS.arrowTimer.stopTimer()
            strongS.gameTimer.stopTimer()
            strongS.overlay.pause()
            strongS.geometryNode.winAnimation()
            strongS.toLobby = true
            strongS.showEndscreen(restartButtonVisible: strongS.isHost)
        }
    }
    
    func receivedItem(_ itemName: String, from peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            let item = strongS.itemManager.getSpecificItem(itemName, for: .multi)
            item.controller = strongS
            strongS.geometryNode.clickable = false
            strongS.geometryNode.pause()
            strongS.overlay.showOpponentItem(item, [strongS.gameTimer, strongS.arrowTimer])
        }
    }
    
    func receivedReadyToPlay(from peer: MCPeerID, _ isReady: Bool) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            if strongS.isHost {
                strongS.peersReady += 1
                if strongS.peersReady == strongS.mpcManager.session.connectedPeers.count {
                    strongS.mpcManager.sendData(messageType: .startGame, messageValue: "", toPeers: strongS.mpcManager.session.connectedPeers)
                    strongS.startGame()
                    
                    strongS.peersReady = 0
                }
            }
        }
    }
    
    func receivedRestart() {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.restart()
        }
    }
    
    func receivedLeftGame(from peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.toLobby = true
            strongS.showEndscreen(restartButtonVisible: false)
        }
    }
    
    func receivedChangedTime(_ by: Double, from peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            strongS.opponentHealthBar.currentTime += by
        }
    }
}

extension GiantWarsController : MultipeerSessionManagerDelegate {
    func userLeft(user peer: MCPeerID) {
        OperationQueue.main.addOperation {[weak self] in
            guard let strongS = self else {return}
            if peer.description == strongS.leader.description {
                strongS.toLobby = false
                strongS.showEndscreen(restartButtonVisible: false)
            } else if strongS.isHost && strongS.mpcManager.session.connectedPeers.count == 0 {
                strongS.toLobby = true
                strongS.showEndscreen(restartButtonVisible: false)
            }
        }
    }
    
    func userJoined(user peer: MCPeerID) {}
}
