//
//  ProfileImageMaker.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 28.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SpriteKit

class ProfileImageMaker {
    static let imageMaker = ProfileImageMaker()
    
    private var context : CIContext!
    private var bwFilter : CIFilter!
    
    private let pulseInterval : Double = 2.0
    private let transperancy : CGFloat = 0.9
    private let reduceFactor : CGFloat = 15
    private let startAngle = CGFloat(.pi / 2.0)
    
    private init() {
        context = CIContext()
        bwFilter = CIFilter(name: "CIColorControls")!
    }
    
    func createProfileImage(from image: UIImage, favoriteColor color: UIColor, radius: CGFloat) -> UIImage {
        let ciImage = CoreImage.CIImage(image: image)!
        bwFilter.setValuesForKeys([kCIInputImageKey: ciImage, kCIInputBrightnessKey:NSNumber(value: 0.0), kCIInputContrastKey:NSNumber(value: 1.1), kCIInputSaturationKey:NSNumber(value: 0.0)])
        let bwImage = (bwFilter.outputImage)!
        
        
        // Adjust exposure
        let exposureFilter = CIFilter(name: "CIExposureAdjust")!
        exposureFilter.setValuesForKeys([kCIInputImageKey:bwImage, kCIInputEVKey:NSNumber(value: 0.7)])
        let expImage = (exposureFilter.outputImage)!
        
        let bwCGIImage = context.createCGImage(expImage, from: ciImage.extent)
        let resultImage = UIImage(cgImage: bwCGIImage!, scale: 1.0, orientation: image.imageOrientation)
        
        let texture = SKTexture(image: resultImage)
        
        let path =  UIBezierPath(
            roundedRect: CGRect.init(
                x: -radius,
                y: -radius,
                width: radius*2,
                height: radius*2),
            cornerRadius: radius
            ).cgPath
        
        let borderNode = SKShapeNode()
        borderNode.path = path
        borderNode.strokeColor = color
        borderNode.lineWidth = radius*2 / (reduceFactor * 2)
        borderNode.fillColor = .white
        borderNode.fillTexture = texture
        borderNode.glowWidth = radius*2 / (reduceFactor * 2)
        borderNode.name = "borderNode"
        borderNode.alpha = transperancy
        
        let colorNode = SKShapeNode()
        let sWidth = radius*2 - radius*2 / (reduceFactor)
        colorNode.path = UIBezierPath(
            roundedRect: CGRect.init(
                x: -sWidth/2,
                y: -sWidth/2,
                width: sWidth,
                height: sWidth),
            cornerRadius: sWidth/2
            ).cgPath

        colorNode.lineWidth = radius*2 / (reduceFactor * 4)
        colorNode.strokeColor = .black
        colorNode.fillColor = color
        colorNode.blendMode = .multiply
        colorNode.isAntialiased = false
        colorNode.lineCap = CGLineCap(rawValue: 1)!
        colorNode.name = "colorNode"
        
        borderNode.addChild(colorNode)
        
        let newTexture = SKView().texture(from: borderNode)
        
        let backgroundNode = SKShapeNode()
        backgroundNode.path = path
        backgroundNode.strokeColor = color
        backgroundNode.lineWidth = radius*2 / (reduceFactor * 2)
        backgroundNode.fillColor = .black
        backgroundNode.name = "backgroundNode"
        backgroundNode.alpha = 1.0
        
        let sprite = SKSpriteNode(texture: newTexture, color: .black, size: CGSize(width: radius*2, height: radius*2))
        backgroundNode.addChild(sprite)
        
        let finalTexture = SKView().texture(from: backgroundNode)
        let newCG = finalTexture!.cgImage()
        
        let newImage = UIImage(cgImage: newCG, scale: 1.0, orientation: image.imageOrientation)
        
        return newImage
    }
}

