//
//  SphereNode.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 04.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit

protocol SphereNodeDelegate : class {
    func countdownFinished()
}

class SphereNode: SCNNode, Pausable {
    fileprivate var countdownTimer : TimeManager?
    fileprivate let sphereNode: SCNNode
    fileprivate let particleNode: SCNNode
    fileprivate var arrows = [String : UIImage]()
    fileprivate var clickableCounter = 1
    fileprivate let positiveColor: UIColor
    fileprivate let negativeColor : UIColor
    fileprivate var pausedSphere = false
    fileprivate var gameOver = false
    fileprivate let sphereOrientation : SCNVector4
    
    var clickable = false {
        didSet {
            if clickable == false {
                clickableCounter += 1
            } else {
                clickableCounter -= 1
                if clickableCounter > 0 {
                    clickableCounter -= 1
                    clickable = false
                }
                if clickableCounter < 0 {clickableCounter = 0}
            }
        }
    }
    
    var currentDirection: Direction
    var rotatingSpeed = 0.3
    weak var delegate : SphereNodeDelegate?

    init(viewSize: CGSize, positiveColor color: UIColor, negativeColor ncolor: UIColor, firstDirection: Direction, orientation angle: SCNVector4) {
        positiveColor = color
        negativeColor = ncolor
        currentDirection = firstDirection
        sphereOrientation = angle
        
        let sphere = SCNSphere(radius: viewSize.width / 250)
        sphere.segmentCount = 48
        
        sphereNode = SCNNode(geometry: sphere)
        sphereNode.name = "sphere"
        
        particleNode = SCNNode()
        particleNode.name = "particle"
        
        super.init()
        
        Direction.allDirections.forEach { direction in
            arrows[direction.rawValue] = UIImage(named: "sphere-alpha-\(direction.rawValue)")
        }
        
        for number in 1...3 {
            arrows["\(number)"] = UIImage(named: "sphere-alpha-\(number)")
        }
        
        arrows["empty"] = #imageLiteral(resourceName: "sphere-alpha")
        
        arrows["game-over"] = #imageLiteral(resourceName: "sphere-alpha-game-over")
        
        arrows["you-won"] = #imageLiteral(resourceName: "sphere-alpha-you-won")
        
        let material = sphereNode.geometry?.firstMaterial
        material?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        material?.diffuse.contents = UIColor.white
        material?.roughness.contents = 0.3
        material?.metalness.contents = 1.0
        material?.normal.contents = #imageLiteral(resourceName: "sphere-normal")
        material?.transparent.contents = arrows["empty"]
        
        let particle = SCNParticleSystem(named: "Smoke.scnp", inDirectory: nil)!
        particle.particleColor = positiveColor
        (particle.emitterShape as! SCNSphere).radius = sphere.radius * 0.8
        particle.particleSize = sphere.radius * 0.7
        particleNode.addParticleSystem(particle)
        particleNode.position = SCNVector3(x: Float(particle.particleSize/30), y: -Float(particle.particleSize/7), z: -Float(particle.particleSize))
        particleNode.rotation = SCNVector4Make(1, 0, 0, -10 * Float((Double.pi) / 180))
                
        self.addChildNode(particleNode)
        self.addChildNode(sphereNode)
        self.rotation = sphereOrientation
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getCurrentVector() -> SCNVector3 {
        switch currentDirection {
        case .up:
            return SCNVector3(x: -1, y: 0, z: 0)
        case .upRight:
            return SCNVector3(x: -1, y: 1, z: 0)
        case .right:
            return SCNVector3(x: 0, y: 1, z: 0)
        case .downRight:
            return SCNVector3(x: 1, y: 1, z: 0)
        case .down:
            return SCNVector3(x: 1, y: 0, z: 0)
        case .downLeft:
            return SCNVector3(x: 1, y: -1, z: 0)
        case .left:
            return SCNVector3(x: 0, y: -1, z: 0)
        case .upLeft:
            return SCNVector3(x: -1, y: -1, z: 0)
        }
    }
    
    fileprivate func rotateAndSwap(to direction: Direction, _ timers: [TimeManager]? = nil) {
        clickable = false
        let vector = getCurrentVector()
        let action = SCNAction.rotate(by: 360 * CGFloat((Double.pi) / 180), around: vector, duration: rotatingSpeed)

        timers?.forEach {
            $0.resetRemainingTime()
            $0.freezeTimer(forSeconds: rotatingSpeed + 0.01)
        }
        
        sphereNode.runAction(action)
        
        let when = DispatchTime.now() + rotatingSpeed / 2
        let clickTimer = DispatchTime.now() + rotatingSpeed + 0.01
        
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            guard let strongS = self else {return}
            
            strongS.currentDirection = direction
            if !strongS.pausedSphere {
                let currentTexture = strongS.sphereNode.geometry?.firstMaterial?.transparent.contents as! UIImage
                if currentTexture != strongS.arrows[direction.rawValue] {strongS.sphereNode.geometry?.firstMaterial?.transparent.contents = strongS.arrows[direction.rawValue]}
            } else { strongS.sphereNode.geometry?.firstMaterial?.transparent.contents = strongS.arrows["empty"]}
        }
        
        DispatchQueue.main.asyncAfter(deadline: clickTimer) {[weak self] in
            guard let strongS = self else {return}
            
            if !strongS.pausedSphere {strongS.clickable = true}
        }
    }
    
    func wrongDirection(_ newDirection: Direction, _ timersToStop: [TimeManager]? = nil) {
        changeParticleColor(to: negativeColor)
        rotateAndSwap(to: newDirection, timersToStop)
    }
    
    func correctDirection(_ newDirection: Direction, _ timersToStop: [TimeManager]? = nil) {
        changeParticleColor(to: positiveColor)
        rotateAndSwap(to: newDirection, timersToStop)
    }
    
    func changeParticleColor(to color: UIColor) {
        particleNode.particleSystems?.first?.particleColor = color
    }
    
    func updateParticles(to progress: CGFloat) {
        particleNode.particleSystems?.first?.particleSize = (sphereNode.geometry as! SCNSphere).radius * 0.7 * progress
        (particleNode.particleSystems?.first?.emitterShape as? SCNSphere)?.radius = (sphereNode.geometry as! SCNSphere).radius * 0.8 * progress
    }
    
    func startCountdown(with seconds: Double) {
        countdownTimer = TimeManager(maxTime: seconds, timerName: "countdownTimer", maxTimeIntervalForReduction: 1)
        countdownTimer!.delegate = self
        countdownTimer!.startTimer()
    }
    
    func gameOverAnimation() {
        self.removeAllActions()
        self.removeAllAnimations()
        self.rotation = sphereOrientation
        gameOver = true
        
        let when = DispatchTime.now() + rotatingSpeed / 2
        
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            guard let strongS = self else {return}
            
            strongS.sphereNode.geometry?.firstMaterial?.transparent.contents = strongS.arrows["game-over"]
        }
    }
    
    func winAnimation() {
        self.removeAllActions()
        self.removeAllAnimations()
        self.rotation = sphereOrientation
        gameOver = true
        
        let when = DispatchTime.now() + rotatingSpeed / 2
        
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            guard let strongS = self else {return}
            
            strongS.sphereNode.geometry?.firstMaterial?.transparent.contents = strongS.arrows["you-won"]
        }
    }
    
    func pause() {
        sphereNode.geometry?.firstMaterial?.transparent.contents = arrows["empty"]
        pausedSphere = true
        clickable = false
        countdownTimer?.stopTimer()
    }
    
    func resume() {
        self.rotation = sphereOrientation
        var alphaTexture = arrows[currentDirection.rawValue]
        if gameOver {alphaTexture = arrows["game-over"]}
        if countdownTimer != nil {alphaTexture = arrows["empty"]}
        sphereNode.geometry?.firstMaterial?.transparent.contents = alphaTexture
        pausedSphere = false
        clickable = true
        countdownTimer?.startTimer()
    }
    
    func reset() {
        sphereNode.removeAllActions()
        sphereNode.removeAllAnimations()
        sphereNode.geometry?.firstMaterial?.transparent.contents = arrows["empty"]
        
        updateParticles(to: 0)
        
        countdownTimer?.stopTimer()
        countdownTimer = nil
        
        clickable = false
        clickableCounter = 1
        particleNode.particleSystems?.first?.particleColor = positiveColor
        pausedSphere = false
        gameOver = false
    }
    
    func removeAllObjects() {
        arrows.removeAll()
        
        if countdownTimer != nil {
            countdownTimer?.stopTimer()
            countdownTimer = nil
        }
        
        for child in self.childNodes {
            child.removeAllActions()
            child.removeAllAnimations()
            child.removeFromParentNode()
        }
        
        delegate = nil
    }
}

extension SphereNode : TimeManagerDelegate {
    func updatedRemainingTime(of name: String, to time: Double) {
        if time > 0 {
            if let image = arrows[time.clearString] {
                let vector = SCNVector3(x: 1, y: 0, z: 0)
                let action = SCNAction.rotate(by: 360 * CGFloat((Double.pi) / 180), around: vector, duration: rotatingSpeed)
                sphereNode.runAction(action)
                
                let when = DispatchTime.now() + rotatingSpeed / 2
                
                DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
                    guard let strongS = self else {return}
                    
                    strongS.sphereNode.geometry?.firstMaterial?.transparent.contents = image
                }
            }
        } else {
            let oldDir = currentDirection
            currentDirection = .down
            rotateAndSwap(to: oldDir)
            
            let startTimer = DispatchTime.now() + rotatingSpeed
            
            DispatchQueue.main.asyncAfter(deadline: startTimer) { [weak self] in
                guard let strongS = self else {return}
                
                strongS.delegate?.countdownFinished()
                strongS.countdownTimer?.stopTimer()
                strongS.countdownTimer = nil
            }
        }
    }
}
