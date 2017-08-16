//
//  TimeManager.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 10.06.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import Foundation


/// Protocol you need to implement for getting TimeManager updates.
protocol TimeManagerDelegate: class {
    
    /// This function gets called whenever the currentMaxTime got updated.
    ///
    /// - Parameter time: The updated currentMaxTime.
    func updatedRemainingTime(of timerName: String, to time: Double)
}


/// A TimeManager provides needed functionality to handle the ingame time and communicates changes with the help of the delegate pattern (via the TimeManagerDelegate protocol).
class TimeManager {
    
// MARK: Properties
    
    
    /// maxTime describes a maximum the currentMaxTime can be.
    let maxTime : Double
    
    
    /// currentMaxTime descripes the maximum the remainingTime can be.
    var currentMaxTime: Double
    
    
    /// timer is the Timer-Object used for counting down.
    var timer : Timer?
    
    /// name of the timer
    let timerName : String
    
    
    /// maxTimeIntervalForReduction describes the interval used for every countdown step of the Timer-Object and the reduction of the currentMaxTime.
    let maxTimeIntervalForReduction : Double
    
    
    /// the current time interval for reduction
    var currentTimeIntervalForReduction : Double
    
    
    /// The delegate is the Object that gets called whenever changes need to be communicated to the outer world.
    weak var delegate: TimeManagerDelegate?
    
    
    ///
    var isFrozen : Bool = false
    
    
    /// remainingTime describes the time left until 0 is reached. Whenever its changed the delegate gets notified (via the updatedCurrentcurrentMaxTime-function).
    var remainingTime : Double {
        didSet {
            delegate?.updatedRemainingTime(of: timerName, to: remainingTime)
            if remainingTime == 0 {
                stopTimer()
            }
        }
    }
    
    
// MARK: Functions
    
    
    /// This function instanciates the timer and triggers the countdown.
    @objc func startTimer() {
        if timer == nil && !isFrozen {
            timer = Timer.scheduledTimer(
                timeInterval: currentTimeIntervalForReduction,
                target: self,
                selector: #selector(self.updateRemainingTime),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    
    /// This function stops the timer / countdown.
    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    
    /// This function freezes the timer / countdown for a supplied period of time.
    ///
    /// - Parameter time: The period of time in seconds.
    func freezeTimer(forSeconds time: Double) {
        stopTimer()
        isFrozen = true
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when) {[weak self] in
            guard let weakSelf = self else {return}
            if weakSelf.isFrozen {
                weakSelf.isFrozen = false
                weakSelf.startTimer()
            }
        }
    }
    
    
    /// This function updates / reduces the remainingTime by the currentTimeIntervalForReduction. It only gets called by the timer.
    @objc private func updateRemainingTime() {
        remainingTime -= currentTimeIntervalForReduction
    }
    
    
    /// This function resets the remainingTime and sets it equal to the maxTime.
    func resetRemainingTime() {
        stopTimer()
        remainingTime = maxTime
        startTimer()
    }
    
    
    /// This function resets the timer to its maximum time
    func reset() {
        stopTimer()
        currentMaxTime = maxTime
        remainingTime = maxTime
        currentTimeIntervalForReduction = maxTimeIntervalForReduction
        isFrozen = false
    }
    
    /// This function sets the current interval for reduction to the specified value (in seconds) if it is lower or equal to the currentMaxTime. Otherwise the currentMaxTime will be the new interval.
    ///
    /// - Parameter interval: The new interval in seconds
    func setCurrentIntervalForReduction(to interval : Double) {
        stopTimer()
        currentTimeIntervalForReduction = (currentMaxTime >= interval) ? interval : currentMaxTime
        startTimer()
    }
    
    
    /// Init Function for TimeManager
    ///
    /// - Parameter max: describes the max time the game is iniciated with
    /// - Parameter name: describes the name of the timer
    /// - Parameter reductionTime: is used to reduce the currentMaxTime
    init(withMaxTime max: Double, withTimerName name: String, withcurrentTimeIntervalForReduction reductionTime: Double) {
        maxTime = max
        currentMaxTime = max
        remainingTime = max
        maxTimeIntervalForReduction = (max <= reductionTime) ? max : reductionTime
        currentTimeIntervalForReduction = maxTimeIntervalForReduction
        timerName = name
    }
}
