//
//  SwitchTimer.swift
//  Switcheroo
//
//  Created by Dennis Dubbert on 06.05.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation

protocol SwitchTimerDelegate {
    func timerDidChange(to seconds: Float, withMax max: Float)
    func gameOver()
}

class SwitchTimer {
    var delegate: SwitchTimerDelegate?
    
    var timer = Timer()
    var isTimerRunning = false
    
    var timeLeft: Float {
        didSet {
            if timeLeft >= 0 {
                delegate?.timerDidChange(to: timeLeft, withMax:maxTime)
            }else{
                delegate?.gameOver()
            }
        }
    }
    
    var maxTime: Float
    
    func runTimer() {
        isTimerRunning = true

    }
    
    @objc func updateTimer() {
        guard isTimerRunning else {return}
        timeLeft -= 0.01
    }
    
    func setTime(to seconds: Float){
        timeLeft = seconds
        maxTime = seconds
    }
    
    func addTime(_ seconds: Float){
        if seconds > 0 {
            timeLeft += seconds
            maxTime = timeLeft
        }
    }
    
    func stopTimer(){
        isTimerRunning = false
    }
    
    func reset(){
        stopTimer()
        timeLeft = 0
        maxTime = 0
    }
    
    init(initialTime: Float) {
        timeLeft = initialTime
        maxTime = initialTime
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
}
