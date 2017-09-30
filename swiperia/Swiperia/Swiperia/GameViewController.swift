//
//  GameViewController.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 03.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    @IBOutlet weak var gameView: SCNView!
    
    var subView : SCNView!
    var gameScene : GameScene!
    var geometryNode: SphereNode!
    var overlay : OverlayScene!
    var progress : ProgressLayer!
    let settingsLayer = CALayer()
    
    var gameTimer : TimeManager!
    var arrowTimer : TimeManager!
    var directionManager : DirectionManager = StandardDirectionManager()
    var gameScore : GameScoreManager!
    
    var positiveColor : UIColor = .orange
    var negativeColor : UIColor = .red
    var activeColor = UIColor.orange
    var stillAlive = true
    var isPaused = false
    
    let itemManager = ItemManager()
    
    private var start:(location:CGPoint, time:TimeInterval)?
    private let minDistance:CGFloat = 5
    private let minSpeed:CGFloat = 100
    private let maxSpeed:CGFloat = 6000
    
    var particleTimer : TimeManager?
    var conButton: UIButton?
    var cancelButton : UIButton?
    var menueActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup observer for notification
        NotificationCenter.default.addObserver(self, selector: #selector(showMenue), name: NSNotification.Name(rawValue: Constants.pauseNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createSettingsIcon()
    }
    
    func createSettingsIcon() {
        let height = view.frame.height / 15
        settingsLayer.frame = CGRect(x: 0, y: 0, width: height, height: height)
        settingsLayer.contents = #imageLiteral(resourceName: "ingameSettings").cgImage
        subView.layer.addSublayer(settingsLayer)
        settingsLayer.position = CGPoint(x: height * 0.75, y: height * 0.75)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in:self.view)
            start = (location, touch.timestamp)
            if settingsLayer.frame.contains(location) && settingsLayer.superlayer != nil {
                showMenue()
            }
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let startTime = self.start?.time,
            let startLocation = self.start?.location {
            let location = touch.location(in:self.view)
            let dx = location.x - startLocation.x
            let dy = location.y - startLocation.y
            let distance = sqrt(dx*dx+dy*dy)
            
            // Check if the user's finger moved a minimum distance
            if distance > minDistance {
                let deltaTime = CGFloat(touch.timestamp - startTime)
                let speed = distance / deltaTime
                
                // Check if the speed was consistent with a swipe
                if speed >= minSpeed && speed <= maxSpeed {
                    
                    // Determine the direction of the swipe
                    let x = abs(dx/distance) > 0.4 ? dx.fign() : 0
                    let y = abs(dy/distance) > 0.4 ? dy.fign() : 0
                    
                    switch (x,y) {
                    case (0,1):
                        respondTo(swipeDirection: .down)
                    case (0,-1):
                        respondTo(swipeDirection: .up)
                    case (-1,0):
                        respondTo(swipeDirection: .left)
                    case (1,0):
                        respondTo(swipeDirection: .right)
                    case (1,1):
                        respondTo(swipeDirection: .downRight)
                    case (-1,-1):
                        respondTo(swipeDirection: .upLeft)
                    case (-1,1):
                        respondTo(swipeDirection: .downLeft)
                    case (1,-1):
                        respondTo(swipeDirection: .upRight)
                    default:
                        break
                    }
                }
            }
        }
        start = nil
    }
    
    func respondTo(swipeDirection gesture: Direction){
        if stillAlive && geometryNode.clickable && gameTimer.remainingTime >= 0 {
            if directionManager.compareCurrentDirection(with: gesture) {
                activeColor = positiveColor
                gameScene.backgroundLight.color = positiveColor
                geometryNode.correctDirection(directionManager.generateDirection(), [gameTimer, arrowTimer])
                progress.barColor = activeColor
                gameScore.scored(successfully: true)
            } else {
                shakeView()
                gameTimer.currentMaxTime -= 1
                activeColor = negativeColor
                gameScene.backgroundLight.color = activeColor
                progress.barColor = activeColor
                gameScore.scored(successfully: false)
                if gameTimer.currentMaxTime > 1 {
                    geometryNode.wrongDirection(directionManager.generateDirection(), [gameTimer, arrowTimer])
                } else {geometryNode.changeParticleColor(to: activeColor)}
            }
        }
    }
    
    func showMenue() {
        if !menueActive {
            menueActive = true
            pause()
            conButton?.removeFromSuperview()
            conButton = nil
            cancelButton?.removeFromSuperview()
            cancelButton = nil
        
            conButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width / 2.5, height: view.frame.height / 10))
        
            conButton!.layer.cornerRadius = 15
            conButton!.layer.borderWidth = conButton!.frame.height / 15
            conButton!.layer.borderColor = positiveColor.cgColor
            conButton!.setTitle("Continue", for: .normal)
            conButton!.setTitleColor(positiveColor, for: .normal)
            conButton!.backgroundColor = .black
        
            view.addSubview(conButton!)
            conButton!.center = CGPoint(x: view.frame.midX - conButton!.frame.width / 1.5, y: view.frame.midY)
            conButton!.addTarget(self, action: #selector(resume), for: .touchUpInside)
        
            cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width / 2.5, height: view.frame.height / 10))
        
            cancelButton!.layer.cornerRadius = 15
            cancelButton!.layer.borderWidth = cancelButton!.frame.height / 15
            cancelButton!.layer.borderColor = negativeColor.cgColor
            cancelButton!.setTitle("Leave", for: .normal)
            cancelButton!.setTitleColor(negativeColor, for: .normal)
            cancelButton!.backgroundColor = .black
        
            view.addSubview(cancelButton!)
            cancelButton!.center = CGPoint(x: view.frame.midX + cancelButton!.frame.width / 1.5, y: view.frame.midY)
            cancelButton!.addTarget(self, action: #selector(leaveGame), for: .touchUpInside)
        }
    }
    
    func shakeView() {
        let duration = geometryNode.rotatingSpeed / 3
        UIView.animate(withDuration: duration, animations: {
            self.subView.frame.origin.x -= 20
        }){_ in
            UIView.animate(withDuration: duration, animations: {
                self.subView.frame.origin.x += 40
            }){_ in
                UIView.animate(withDuration: duration, animations: {
                    self.subView.frame.origin.x -= 20
                })
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        return .all
    }
    
    func showEndscreen(restartButtonVisible visible: Bool) {
        pause()
        menueActive = true
        settingsLayer.removeFromSuperlayer()
    }
    
    func leaveGame() {
        removeAllObjects()
    }

    @objc func pause() {
        settingsLayer.removeFromSuperlayer()
        isPaused = true
        geometryNode.pause()
        MusicPlayer.sharedHelper.pause()
        progress.pause()
        overlay.pause()
        particleTimer?.stopTimer()
        gameTimer.stopTimer()
        arrowTimer.stopTimer()
    }
    
    @objc func resume() {
        if settingsLayer.superlayer == nil { subView.layer.addSublayer(settingsLayer) }
        conButton?.removeFromSuperview()
        conButton = nil
        cancelButton?.removeFromSuperview()
        cancelButton = nil
        menueActive = false
        isPaused = false
        geometryNode.resume()
        MusicPlayer.sharedHelper.resume()
        progress.resume()
        overlay.resume()
        particleTimer?.startTimer()
        gameTimer.startTimer()
        arrowTimer.startTimer()
    }
    
    func reset() {
        stillAlive = false
        
        activeColor = positiveColor
        gameScene.backgroundLight.color = positiveColor
        directionManager = StandardDirectionManager()
        particleTimer?.stopTimer()
        particleTimer = nil
        gameScene.comboChanged(to: 0)
        progress.barColor = positiveColor
        if settingsLayer.superlayer == nil { subView.layer.addSublayer(settingsLayer) }
        
        overlay.reset()
        geometryNode.reset()
        gameScore.reset()
        progress.reset()
        gameTimer.reset()
        arrowTimer.reset()
        stillAlive = true
        menueActive = false
    }
    
    func removeAllObjects() {
        gameTimer.stopTimer()
        arrowTimer.stopTimer()
        
        if particleTimer != nil {
            particleTimer?.stopTimer()
            particleTimer = nil
        }
        
        overlay.removeAllObjects()
        progress.removeAllObjects()
        geometryNode.removeAllObjects()
        gameScene.removeAllObjects()
        settingsLayer.removeFromSuperlayer()
        
        conButton?.removeFromSuperview()
        conButton = nil
        cancelButton?.removeFromSuperview()
        cancelButton = nil
        subView.removeFromSuperview()
        gameView.removeFromSuperview()
        
        gameTimer = nil
        arrowTimer = nil
    }

    func restart() {
        conButton?.removeFromSuperview()
        conButton = nil
        cancelButton?.removeFromSuperview()
        cancelButton = nil
        
        reset()
    }
    
    func startGame() {}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
