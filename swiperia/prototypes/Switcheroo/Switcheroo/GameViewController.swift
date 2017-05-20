//
//  GameViewController.swift
//  Switcheroo
//
//  Created by Dennis Dubbert on 06.05.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit


class GameViewController: UIViewController {
    @IBOutlet weak var secondsLeft: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pictureLabel: UILabel!
    @IBOutlet weak var winstreak: UILabel!
    
    var myTimer: SwitchTimer?
    var directionManager: DirectionManager?
    var active = false
    var finished = false
    
    var start:(location:CGPoint, time:TimeInterval)?
    let minDistance:CGFloat = 5
    let minSpeed:CGFloat = 100
    let maxSpeed:CGFloat = 6000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //try swipes
        
        
        
        //register swipes
        /*let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)*/
        
        //progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 2.0);
        myTimer = SwitchTimer(initialTime: 0)
        secondsLeft.text = "\(myTimer!.timeLeft)"
        myTimer!.delegate = self
        directionManager = DirectionManager(timer: myTimer!, delegateTo: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startPressed(_ sender: Any) {
        if finished{
            reset()
        }else{
            directionManager?.activateNextDirection()
        }
        myTimer?.runTimer()
        active = true
    }
    
    func reset(){
        progressBar.setProgress(1, animated: false)
        directionManager?.reset()
    }
    
    func respondToSwipeGesture(direction: String){
        guard active == true else{return}
        
        switch(direction){
            case "right":
                directionManager?.checkDirectionInput(Directions.right)
            
            case "down":
                directionManager?.checkDirectionInput(Directions.down)
            
            case "left":
                directionManager?.checkDirectionInput(Directions.left)
            
            case "up":
                directionManager?.checkDirectionInput(Directions.up)
            
            case "upLeft":
                directionManager?.checkDirectionInput(Directions.upLeft)
            
            case "upRight":
                directionManager?.checkDirectionInput(Directions.upRight)
            
            case "downLeft":
                directionManager?.checkDirectionInput(Directions.downLeft)
            
            case "downRight":
                directionManager?.checkDirectionInput(Directions.downRight)
            
        default:
            break
        }
    }
    
    /*func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        guard active == true else{return}
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                    directionManager?.checkDirectionInput(Directions.right)
            
            case UISwipeGestureRecognizerDirection.down:
                    directionManager?.checkDirectionInput(Directions.down)
                
            case UISwipeGestureRecognizerDirection.left:
                    directionManager?.checkDirectionInput(Directions.left)
                
            case UISwipeGestureRecognizerDirection.up:
                    directionManager?.checkDirectionInput(Directions.up)
                
            default:
                break
            }
        }
    }*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            start = (touch.location(in:self.view), touch.timestamp)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var swiped = false
        if let touch = touches.first, let startTime = self.start?.time,
            let startLocation = self.start?.location {
            let location = touch.location(in:self.view)
            let dx = location.x - startLocation.x
            let dy = location.y - startLocation.y
            let distance = sqrt(dx*dx+dy*dy)
            
            // Check if the user's finger moved a minimum distance
            if distance > minDistance {
                let deltaTime = CGFloat(touch.timestamp - startTime)
                let speed = distance / deltaTime
                
                // Check if the speed was consistent with a swipe
                if speed >= minSpeed && speed <= maxSpeed {
                    
                    // Determine the direction of the swipe
                    let x = abs(dx/distance) > 0.4 ? dx.fign() : 0
                    let y = abs(dy/distance) > 0.4 ? dy.fign() : 0
                    
                    swiped = true
                    switch (x,y) {
                    case (0,1):
                        respondToSwipeGesture(direction: "down")
                        
                    case (0,-1):
                        respondToSwipeGesture(direction: "up")
                        
                    case (-1,0):
                        respondToSwipeGesture(direction: "left")
                        
                    case (1,0):
                        respondToSwipeGesture(direction: "right")
                        
                    case (1,1):
                        respondToSwipeGesture(direction: "downRight")
                    case (-1,-1):
                        respondToSwipeGesture(direction: "upLeft")
                    case (-1,1):
                        respondToSwipeGesture(direction: "downLeft")
                    case (1,-1):
                        respondToSwipeGesture(direction: "upRight")
                    default:
                        swiped = false
                        break
                    }
                }
            }
        }
        start = nil
        if !swiped {
            // Process non-swipes (taps, etc.)
            print("not a swipe")
        }
    }
    
}

protocol Fignable {
    init()
    static func <(lhs:Self, rhs:Self) -> Bool
}

extension Fignable {
    func fign() -> Int {
        return (self < Self() ? -1 : 1)
    }
}

/* extend signed integer types to Signable */
extension Int: Fignable { }    // already have < and init() functions, OK
extension Int8 : Fignable { }  // ...
extension Int16 : Fignable { }
extension Int32 : Fignable { }
extension Int64 : Fignable { }

/* extend floating point types to Signable */
extension Double : Fignable { }
extension Float : Fignable { }
extension CGFloat : Fignable { }

extension GameViewController: SwitchTimerDelegate, DirectionManagerDelegate {
    
    func timerDidChange(to seconds: Float, withMax max: Float) {
        if seconds > 0.01 {
            let twoDecimalPlaces = String(format: "%.2f", seconds)
            let progress = seconds / max
            
            secondsLeft.text = "\(twoDecimalPlaces)"
            progressBar.setProgress(progress, animated: true)
        }else{
            if active{
                progressBar.setProgress(0, animated: true)
                secondsLeft.text = "0.00"
            }
        }
    }
    
    func gameOver(){
        directionManager?.stopGame()
    }
    
    func directionChanged(direction: String){
        pictureLabel.text = direction
    }
    
    func finishedDirections(score: Int){
        finished = true
        active = false
        pictureLabel.text = "Score: \(score)"
    }
    
    func checkSolution(text: String, count: Int, color: UIColor) {
        if count > 1 {
            winstreak.text = "\(text) winstreak of \(count)!"
        }else{
            winstreak.text = "\(text)!"
        }
        winstreak.textColor = color
        pictureLabel.textColor = color
    }
}
