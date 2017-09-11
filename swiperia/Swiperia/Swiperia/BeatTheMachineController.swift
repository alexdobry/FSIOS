//
//  BeatTheMachineController.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 03.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit
import MultipeerConnectivity

class BeatTheMachineController : GameViewController {
    var profileImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        profileImage = ProfileImageMaker.imageMaker.createProfileImage(from: #imageLiteral(resourceName: "doener"), favoriteColor: .cyan, radius: view.frame.height / 15)
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
        gameScore = GameScoreManager(standardScoreIncreaseAmount: 100, standardAmountForLevelChange: 5, itemProgressFinished: 20)
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
        overlay = OverlayScene(size: gameView.frame.size, positiveColor: positiveColor, negativeColor: negativeColor, true)
        overlay.overlayDelegate = self
        overlay.scoreMultiplicator?.setText(to: "x1.0", withAnimation: false)
        subView.overlaySKScene = overlay
        
        gameView.addSubview(subView)
        gameView.backgroundColor = .black
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
        startGame()
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
    
    override func restart() {
        super.restart()
        
        itemProgressDidChange(to: 0)
        
        startGame()
    }
    
    override func leaveGame() {
        super.leaveGame()
        //TODO: save all results / do segue
        dismiss(animated: true, completion: nil)
    }
    
    override func showEndscreen(restartButtonVisible visible: Bool) {
        super.showEndscreen(restartButtonVisible: visible)
        
        conButton?.removeFromSuperview()
        conButton = nil
        cancelButton?.removeFromSuperview()
        cancelButton = nil
        
        
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
        
        
        cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width / 2.5, height: view.frame.height / 10))
        
        cancelButton!.layer.cornerRadius = 15
        cancelButton!.layer.borderWidth = cancelButton!.frame.height / 15
        cancelButton!.layer.borderColor = negativeColor.cgColor
        cancelButton!.setTitle("Leave", for: .normal)
        cancelButton!.setTitleColor(negativeColor, for: .normal)
        cancelButton!.backgroundColor = .black
        
        view.addSubview(cancelButton!)
        let position = CGPoint(x: view.frame.midX + cancelButton!.frame.width / 1.5, y: view.frame.midY)
    
        cancelButton!.center = position
        cancelButton!.addTarget(self, action: #selector(leaveGame), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

extension BeatTheMachineController: TimeManagerDelegate, OverlaySceneDelegate, GameScoreManagerDelegate, SphereNodeDelegate{
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
                    progress.progress = 0
                    stillAlive = false
                    geometryNode.gameOverAnimation()
                    showEndscreen(restartButtonVisible: true)
                }
                
                break
                
            case arrowTimer.timerName:
                if gameTimer.currentMaxTime > 1 && time <= 0 {
                    shakeView()
                    activeColor = negativeColor
                    gameScene.backgroundLight.color = activeColor
                    gameTimer.currentMaxTime -= 1
                    geometryNode.wrongDirection(directionManager.generateDirection(), [gameTimer, arrowTimer])
                    progress.barColor = activeColor
                    gameScore.scored(successfully: false)
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
            geometryNode.clickable = false
            geometryNode.pause()
            item.controller = self
            overlay.showOpponentItem(item, [gameTimer, arrowTimer])
        }
    }
    
    func opponentItemShown(_ item: Item) {
        geometryNode.resume()
        geometryNode.clickable = true
    }
    
    /// GameScoreManagerDelegate
    func scoreDidChange(to score: Double) {
        overlay.gameScore?.setText(to: "\(score.clearString)", withAnimation: false)
    }
    
    func comboLevelDidChange(to level: Int) {
        let percentage = CGFloat(Double(level) / Double(Constants.MULTIPLICATOR_STEPS.count))
        gameScene.comboChanged(to: percentage)
        
        if level >= 2 {
            gameTimer.currentMaxTime += 1
        }
        
        guard let scoreMultiplicator = overlay.scoreMultiplicator, let score = overlay.gameScore else {return}
        scoreMultiplicator.setText(to: "x\(String(format: "%.1f", gameScore.currentMultiplicator))")
        score.position = CGPoint(x: overlay.width * 0.99 - scoreMultiplicator.frame.width, y: overlay.height - score.frame.height * 1.5)
        
        if level > 0 {
            score.addPositiveAnimation()
            scoreMultiplicator.addPositiveAnimation()
        } else {
            score.addNegativeAnimation()
            scoreMultiplicator.addNegativeAnimation()
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
        overlay.playerItem = itemManager.randomItem(for: .single)
    }
}
