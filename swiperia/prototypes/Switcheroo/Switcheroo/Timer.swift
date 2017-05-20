//
//  Timer.swift
//  Switcheroo
//
//  Created by Dennis Dubbert on 06.05.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation

protocol TimerDelegate {
    func timerDidChange(to seconds: Int)
}

struct SwitchTimer {
    var delegate: TimerDelegate?
    
    var timer = Timer()
    var isTimerRunning = false
    
    var timeLeft = 10 {
        didSet {
            if(timeLeft >= 0){
                delegate?.timerDidChange(to: timeLeft)
            }
        }
    }
    
    mutating func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    mutating func updateTimer() {
        timeLeft -= 1
    }
    
    
}
