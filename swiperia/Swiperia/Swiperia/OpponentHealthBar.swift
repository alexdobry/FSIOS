//
//  OpponentHealthBar.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 08.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import UIKit

class OpponentHealthBar : UIView {
    private var healthBar : UIProgressView
    private var imageView : UIImageView
    var barColor : UIColor {
        didSet {
            healthBar.progressTintColor = barColor
        }
    }
    
    private var healthProgress: CGFloat {
        get {
            return CGFloat(healthBar.progress)
        }
        set {
            if newValue > 1 {
                healthBar.setProgress(1, animated: true)
            } else if newValue < 0 {
                healthBar.setProgress(0, animated: true)
            } else {
                healthBar.setProgress(Float(newValue), animated: true)
            }
        }
    }
    
    private var maxTime : Double
    var currentTime : Double {
        didSet {
            if currentTime > maxTime {
                currentTime = maxTime
            }else if currentTime >= 0 {
                healthProgress = CGFloat(currentTime / maxTime)
            }
        }
    }
    
    private var healthBarMaxWidth : CGFloat
    
    init(frame: CGRect, barWidth: CGFloat, barColor: UIColor, image: UIImage, maxTime: Double) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        imageView.image = image
        
        healthBarMaxWidth = frame.width - frame.height
        
        healthBar = UIProgressView(progressViewStyle: .bar)
        healthBar.trackTintColor = .white
        healthBar.progressTintColor = barColor
        self.barColor = barColor
        healthBar.frame = CGRect(x: 0, y: 0, width: healthBarMaxWidth, height: barWidth)
        healthBar.transform = CGAffineTransform(rotationAngle: CGFloat(180 / 180.0 * .pi))
        self.maxTime = maxTime
        currentTime = maxTime
        
        super.init(frame: frame)
        
        healthProgress = 1

        alpha = 0.5
        
        addSubview(imageView)
        addSubview(healthBar)
        
        imageView.center.x = frame.width - imageView.frame.width / 2
        imageView.center.y = frame.height / 2
        
        healthBar.center.x = healthBar.frame.width / 2
        healthBar.center.y = frame.height / 2
    }
    
    func reset() {
        currentTime = maxTime
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
