//
//  self.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 19.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SceneKit

class GameScene : SCNScene {
    let backgroundLight : SCNLight
    let sphereLight : SCNLight
    let positiveColor : UIColor
    
    init(viewSize: CGSize, positiveColor: UIColor) {
        backgroundLight = SCNLight()
        sphereLight = SCNLight()
        self.positiveColor = positiveColor
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func comboChanged(to percentage: CGFloat) {}
    
    
    func removeAllObjects() {
        for child in self.rootNode.childNodes {
            child.removeAllAnimations()
            child.removeAllActions()
            child.removeFromParentNode()
        }
        
        self.removeAllParticleSystems()
    }
}

class GolemScene : GameScene {
    let leftEye : SCNNode
    let rightEye : SCNNode
    let eyeMinSize : CGFloat
    let particleMinSize : CGFloat
    let eyeMaxSize : CGFloat
    let particleMaxSize : CGFloat
    let minBirthrate : CGFloat
    let maxBirthrate : CGFloat
    let minVelocity : CGFloat
    let maxVelocity : CGFloat
    let minLifespan : CGFloat
    let maxLifespan : CGFloat
    
    override init(viewSize: CGSize, positiveColor: UIColor) {
        leftEye = SCNNode()
        rightEye = SCNNode()
        eyeMinSize = viewSize.width / 32000
        particleMinSize = viewSize.width / 16000
        eyeMaxSize = viewSize.width / 2000
        particleMaxSize = viewSize.width / 8000
        
        //Setup particles
        let leftEyeParticle = SCNParticleSystem(named: "Eye.scnp", inDirectory: nil)!
        leftEyeParticle.emittingDirection = SCNVector3Make(-1, 0, 0)
        minLifespan = leftEyeParticle.particleLifeSpan
        maxLifespan = 0.5
        minVelocity = leftEyeParticle.particleVelocity
        maxVelocity = 1
        minBirthrate = leftEyeParticle.birthRate
        maxBirthrate = 1000
        
        let rightEyeParticle = SCNParticleSystem(named: "Eye.scnp", inDirectory: nil)!
        
        leftEye.addParticleSystem(leftEyeParticle)
        rightEye.addParticleSystem(rightEyeParticle)
        
        leftEye.position = SCNVector3Make(-0.6, 4, -1)
        rightEye.position = SCNVector3Make(0.6, 4, -1)
        
        super.init(viewSize: viewSize, positiveColor: positiveColor)
        
        self.rootNode.addChildNode(leftEye)
        self.rootNode.addChildNode(rightEye)
        comboChanged(to: 0)
        
        // Setup a new scene
        let golemNode = SCNScene(named: "golem.obj")!.rootNode.childNodes[0]
        self.rootNode.addChildNode(golemNode)
        golemNode.categoryBitMask = Constants.BACKGROUND_LIGHT_TYPE
        
        let action = SCNAction.moveBy(x: 0, y: -12, z: -9, duration: 0)
        golemNode.rotation = SCNVector4Make(1, 0, 0, 20 * Float((Double.pi) / 180))
        golemNode.runAction(action)
        golemNode.scale = SCNVector3(x: 2, y: 2, z: 1)
        
        let material = golemNode.geometry?.firstMaterial
        material?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        material?.metalness.contents = 0.95
        material?.roughness.contents = 1.0
        material?.diffuse.contents = UIColor.black
        material?.normal.contents = #imageLiteral(resourceName: "sphere-normal")
        
        // Setup lights
        backgroundLight.type = SCNLight.LightType.omni
        backgroundLight.color = positiveColor
        backgroundLight.intensity = 1000
        backgroundLight.categoryBitMask = Constants.BACKGROUND_LIGHT_TYPE
        
        let leftHandsLightNode = SCNNode()
        leftHandsLightNode.light = backgroundLight
        leftHandsLightNode.position = SCNVector3Make(-1.3, -1.8, -1.2)
        leftHandsLightNode.name = "leftHandsLightNode"
        
        let rightHandsLightNode = SCNNode()
        rightHandsLightNode.light = backgroundLight
        rightHandsLightNode.position = SCNVector3Make(1, -1.8, -1.2)
        rightHandsLightNode.name = "rightHandsLightNode"
        
        let faceLightNode = SCNNode()
        faceLightNode.light = backgroundLight
        faceLightNode.position = SCNVector3Make(0, 1.3, -2)
        faceLightNode.name = "faceLightNode"
        
        let glowLight = SCNLight()
        glowLight.type = SCNLight.LightType.omni
        glowLight.color = UIColor.white
        glowLight.intensity = 3000
        
        let glowLightNode = SCNNode()
        glowLightNode.light = glowLight
        glowLightNode.position = SCNVector3Make(20, 20, 4)
        glowLightNode.name = "glowLightNode"
        
        let backLight = SCNLight()
        backLight.type = SCNLight.LightType.omni
        backLight.color = UIColor.white
        backLight.intensity = 1000
        backLight.categoryBitMask = Constants.BACKGROUND_LIGHT_TYPE
        
        let backLightNode = SCNNode()
        backLightNode.light = backLight
        backLightNode.position = SCNVector3Make(0, 5.5, -11)
        backLightNode.name = "backLightnode"
        
        let frontLightNode = SCNNode()
        frontLightNode.light = backLight
        frontLightNode.position = SCNVector3Make(0, 60, -20)
        frontLightNode.name = "frontLightnode"
        
        let chestLightNode = SCNNode()
        chestLightNode.light = backgroundLight
        chestLightNode.position = SCNVector3Make(0, -0.5, -2)
        chestLightNode.name = "chestLightNode"
        
        sphereLight.type = .ambient
        sphereLight.color = positiveColor
        sphereLight.intensity = 200
        sphereLight.categoryBitMask = Constants.SPHERE_LIGHT_TYPE
        
        let sphereLightNode = SCNNode()
        sphereLightNode.light = sphereLight
        sphereLightNode.name = "sphereLightNode"
        
        self.rootNode.addChildNode(leftHandsLightNode)
        self.rootNode.addChildNode(rightHandsLightNode)
        self.rootNode.addChildNode(faceLightNode)
        self.rootNode.addChildNode(glowLightNode)
        self.rootNode.addChildNode(backLightNode)
        self.rootNode.addChildNode(frontLightNode)
        self.rootNode.addChildNode(chestLightNode)
        self.rootNode.addChildNode(sphereLightNode)
        
        // Setup the camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.xFov = 12
        cameraNode.camera?.yFov = 12
        cameraNode.name = "cameraNode"
        self.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 7.9, z: 22)
        cameraNode.rotation = SCNVector4Make(1, 0, 0, -14 * Float((Double.pi) / 180))
        
        // Setup background
        self.background.contents = UIColor.black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func comboChanged(to percentage: CGFloat) {
        let color = UIColor(red: 1, green: 1, blue: 1, alpha: 1).interpolateRGBColorTo(end: positiveColor, fraction: percentage)
        leftEye.particleSystems?.first?.particleColor = color
        (leftEye.particleSystems?.first?.emitterShape as! SCNSphere).radius = percentage * (eyeMaxSize - eyeMinSize) + eyeMinSize
        leftEye.particleSystems?.first?.particleSize = percentage * (particleMaxSize - particleMinSize) + particleMinSize
        leftEye.particleSystems?.first?.particleLifeSpan = percentage * (maxLifespan - minLifespan) + minLifespan
        leftEye.particleSystems?.first?.particleVelocity = percentage * (maxVelocity - minVelocity) + minVelocity
        leftEye.particleSystems?.first?.birthRate = percentage * (maxBirthrate - minBirthrate) + minBirthrate
        
        rightEye.particleSystems?.first?.particleColor = color
        (rightEye.particleSystems?.first?.emitterShape as! SCNSphere).radius = percentage * (eyeMaxSize - eyeMinSize) + eyeMinSize
        rightEye.particleSystems?.first?.particleSize = percentage * (particleMaxSize - particleMinSize) + particleMinSize
        rightEye.particleSystems?.first?.particleLifeSpan = percentage * (maxLifespan - minLifespan) + minLifespan
        rightEye.particleSystems?.first?.particleVelocity = percentage * (maxVelocity - minVelocity) + minVelocity
        rightEye.particleSystems?.first?.birthRate = percentage * (maxBirthrate - minBirthrate) + minBirthrate
    }
}
