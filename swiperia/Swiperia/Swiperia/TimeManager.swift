//
//  TimeManager.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 27.05.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation

/// Protocol you need to implement for getting TimeManager updates.
protocol TimeManagerDelegate: class {
    
    /// This function gets called whenever the currentMaxTime got updated.
    ///
    /// - Parameter name: The name of the TimeManager that got updated
    /// - Parameter time: The updated currentMaxTime.
    func updatedRemainingTime(of name: String, to time: Double)
}


/// A TimeManager provides needed functionality to handle the ingame time and communicates changes with the help of the delegate pattern (via the TimeManagerDelegate protocol).
class TimeManager {
    
    // MARK: Properties
    
    /// name of the timer for recognition purposes
    let timerName : String
    
    
    /// timeIntervalForReduction describes the interval used for every countdown step of the Timer-Object and the reduction of the currentcurrentMaxTime.
    let maxTimeIntervalForReduction : Double
    
    
    /// the current timeIntervalForReduction
    var currentTimeIntervalForReduction : Double
    
    
    /// maxTime describes a maximum the currentMaxTime can be.
    let maxTime : Double
    
    
    /// currentMaxTime describes a maximum the remainingTime can be.
    var currentMaxTime : Double {
        didSet {
            if currentMaxTime > maxTime {
                currentMaxTime = maxTime
            }
            
            if currentMaxTime < remainingTime {
                remainingTime = currentMaxTime
            }
        }
    }
    
    
    /// timer is the Timer-Object used for counting down.
    private var timer : Timer?
    
    
    /// The delegate is the Object that gets called whenever changes need to be communicated to the outer world.
    weak var delegate: TimeManagerDelegate?
    
    
    /// the delegate used for auto deletion
    var autoReset: Bool
    
    
    /// count stops
    private var stopCounter = 1
    
    
    /// remainingTime describes the time left until 0 is reached. Whenever its changed the delegate gets notified (via the updatedCurrentMaxTime-function).
    var remainingTime : Double {
        didSet {
            delegate?.updatedRemainingTime(of: timerName, to: remainingTime)
            if remainingTime <= 0.0 && autoReset{
                resetRemainingTime()
            }
        }
    }
    
    // MARK: Functions
    
    /// This function instanciates the timer and triggers the countdown.
    @objc func startTimer() {
        stopCounter -= 1
        if timer == nil && stopCounter == 0 {
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
        stopCounter += 1
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
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when) {[weak self] in
            guard let strongS = self else {return}
            strongS.startTimer()
        }
    }
    
    
    /// This function updates / reduces the remainingTime by the timeIntervalForReduction. It only gets called by the timer.
    @objc private func updateRemainingTime() {
        remainingTime -= currentTimeIntervalForReduction
    }
    
    /// This function resets the remainingTime and sets it equal to the maxTime.
    func resetRemainingTime() {
        stopTimer()
        remainingTime = currentMaxTime
        startTimer()
    }
    
    /// This function sets the currentIntervalForReduction to the specified value (in seconds) if it is lower or equal to the currentMaxTime. Otherwise the currentMaxTime will be the new interval
    ///
    /// - Parameter interval: The new interval in seconds
    func setCurrentIntervalForReduction(to interval: Double) {
        stopTimer()
        currentTimeIntervalForReduction = (currentMaxTime >= interval) ? interval : currentMaxTime
        startTimer()
    }
    
    
    /// This functions resets the timer to its maximum time
    func reset() {
        stopTimer()
        let tempDel = delegate
        delegate = nil
        currentMaxTime = maxTime
        remainingTime = maxTime
        currentTimeIntervalForReduction = maxTimeIntervalForReduction
        stopCounter = 1
        delegate = tempDel
    }
    
    /// Init function for TimeManager
    ///
    /// - Parameter max: The maximum time for the countdown in seconds
    /// - Parameter name: The name of the TimeManager
    /// - Parameter interval: The amount the currentcurrentMaxTime gets reduced by every tick in seconds
    init(maxTime max: Double, timerName name: String, maxTimeIntervalForReduction interval: Double,_ autoReset: Bool = false) {
        maxTime = max
        currentMaxTime = max
        remainingTime = max
        timerName = name
        maxTimeIntervalForReduction = (max <= interval) ? max : interval
        currentTimeIntervalForReduction = maxTimeIntervalForReduction
        self.autoReset = autoReset
    }
}
