//
//  ProgressLayer.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 22.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import SceneKit

class ProgressLayer : CAShapeLayer, Pausable {
    fileprivate var countdownTimer : TimeManager?
    private let startAngle = -CGFloat(.pi / 2.0)
    var progress: CGFloat {
        get {
            return self.strokeEnd
        }
        set {
            if newValue > 1 {
                self.strokeEnd = 1
            } else if newValue < 0 {
                self.strokeEnd = 0
            } else {
                self.strokeEnd = newValue
            }
            
            progressDelegate?.updateProgress(to: self.progress)
        }
    }
    
    var barColor : UIColor = .white {
        didSet {
            self.strokeColor = barColor.cgColor
        }
    }
    
    var progressDelegate : ProgressSpark?
    
    init(radius: CGFloat, barWidth: CGFloat, barColor: UIColor) {
        super.init()
        self.strokeColor = barColor.cgColor
        self.lineWidth = barWidth
        self.fillColor = UIColor.clear.cgColor
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: radius * 2, height: radius * 2))
        self.frame = rect
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2,y: frame.height / 2) ,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: startAngle + CGFloat(2.0 * .pi),
                                clockwise: true).cgPath
        self.path = path
        self.opacity = 0.3
        self.progress = 0
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillProgress(in seconds: Double) {
        countdownTimer = TimeManager(maxTime: seconds, timerName: "buildUp", maxTimeIntervalForReduction: 0.05)
        countdownTimer!.delegate = self
        countdownTimer!.startTimer()
    }
    
    func pause() {
        speed = 0.0
        countdownTimer?.stopTimer()
    }
    
    func resume() {
        speed = 1.0
        countdownTimer?.startTimer()
    }
    
    func reset() {
        countdownTimer?.stopTimer()
        countdownTimer = nil
        progress = 0
        speed = 1.0
    }
    
    func removeAllObjects() {
        self.removeAllAnimations()
        self.removeFromSuperlayer()
        countdownTimer?.stopTimer()
        countdownTimer = nil
    }
}

extension ProgressLayer : TimeManagerDelegate {
    func updatedRemainingTime(of name: String, to time: Double) {
        if time > 0 {
            self.progress = CGFloat(1 - time / countdownTimer!.currentMaxTime)
        } else {
            progressDelegate?.sparkShouldAppear = true
            countdownTimer!.stopTimer()
            countdownTimer = nil
            self.actions = ["strokeEnd" : NSNull()]
        }
    }
}
