//
//  GameTimer.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 10.06.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import Foundation


/// Protocol you need to implement for getting GameTimer updates.
protocol GameTimerDelegate {
    
    /// This function gets called whenever the gametime got updated.
    ///
    /// - Parameter time: The updated gametime.
    func updatedRemainingGameTime(to time: Double)
}


/// A GameTimer provides needed functionality to handle the ingame time and communicates changes with the help of the delegate pattern (via the GameTimerDelegate protocol).
class GameTimer {
    
    // MARK: Properties
    
    
    /// maxTime describes a maximum the currentGameTime can be.
    private var maxTime : Double
    
    
    /// timer is the Timer-Object used for counting down.
    private var timer : Timer
    
    
    /// timeIntervalForReduction describes the interval used for every countdown step of the Timer-Object and the reduction of the currentGameTime.
    private let timeIntervalForReduction = 0.01
    
    
    /// The delegate is the Object that gets called whenever changes need to be communicated to the outer world.
    private var delegate: GameTimerDelegate?
    
    
    /// remainingGameTime describes the time left until 0 is reached. Whenever its changed the delegate gets notified (via the updatedCurrentGameTime-function).
    private var remainingGameTime : Double {
        
        didSet {
            delegate?.updatedRemainingGameTime(to: remainingGameTime)
        }
    }
    
    
    // MARK: Functions
    
    
    /// This function instanciates the timer and triggers the countdown.
    @objc func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: timeIntervalForReduction, target: self, selector: #selector(self.updateRemainingTime), userInfo: nil, repeats: true)
    }
    
    
    /// This function stops the timer / countdown.
    func stopTimer() {
        timer.invalidate()
    }
    
    
    /// This function freezes the timer / countdown for a supplied period of time.
    ///
    /// - Parameter time: The period of time in seconds.
    func freezeTimer(for time: Double) {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: false)
    }
    
    
    /// This function updates / reduces the remainingGameTime by the timeIntervalForReduction. It only gets called by the timer.
    @objc private func updateRemainingTime() {
        remainingGameTime -= timeIntervalForReduction
    }
    
    
    /// This function reduces the maxTime by a supplied value.
    ///
    /// - Parameter time: The value in seconds.
    func reduceMaxTime(by time: Double) {
        maxTime -= time
    }
    
    
    /// This function increases the maxTime by a supplied value.
    ///
    /// - Parameter time: The value in seconds.
    func increaseMaxTime(by time: Double) {
        maxTime += time
    }
    
    /// This function reduces the remainingGameTime by a supplied value.
    ///
    /// - Parameter time: The value in seconds.
    func reduceCurrentGameTime(by time: Double) {
        remainingGameTime -= time
    }
    
    
    /// This function increases the remainingGameTime by a supplied value.
    ///
    /// - Parameter time: The value in seconds.
    func increaseCurrentGameTime(by time: Double) {
        remainingGameTime += time
    }
    
    
    /// This function resets the remainingGameTime and sets it equal to the maxTime.
    func resetCurrentGameTime() {
        remainingGameTime = maxTime
    }
    
    
    /// This function changes the delegate to the one supplied so that only the new delegate gets notified after time changes.
    ///
    /// - Parameter newDelegate: The new delegate that implemented the GameTimerDelegate-Protocol.
    func setDelegate(to newDelegate: GameTimerDelegate) {
        delegate = newDelegate
    }
    
    init(withMaxTime time: Double) {
        maxTime = time;
        remainingGameTime = time;
        timer = Timer()
    }
}

