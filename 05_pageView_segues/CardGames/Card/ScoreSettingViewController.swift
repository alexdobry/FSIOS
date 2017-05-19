//
//  ScoreSettingViewController.swift
//  Card
//
//  Created by Alex on 15.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ScoreSettingViewController: UIViewController {
    
    private struct SliderConstants {
        static let Minimum: Float = 0.0
        static let Maximum: Float = 10.0
        static let Value: Float = 5.0
    }
    
    // MARK: public api - prepare and unwind
    
    var values: (increment: Float, decrement: Float)? {
        didSet { updateUI() }
    }
    
    // MARK: outlets

    @IBOutlet weak var incrementLabel: UILabel!
    @IBOutlet weak var decrementLabel: UILabel!
    
    @IBOutlet weak var incrementSlider: UISlider!
    @IBOutlet weak var decrementSlider: UISlider!

    // MARK: viewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        incrementSlider.minimumValue = SliderConstants.Minimum
        incrementSlider.maximumValue = SliderConstants.Maximum
        incrementSlider.value = values!.increment
        
        decrementSlider.minimumValue = SliderConstants.Minimum
        decrementSlider.maximumValue = SliderConstants.Maximum
        decrementSlider.value = values!.decrement
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }

    private func updateUI() {
        incrementLabel?.text = "Increment Score by".appendingFormat(" %d", Int(values!.increment))
        decrementLabel?.text = "Decrement Score by".appendingFormat(" %d", Int(values!.decrement))
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        switch sender {
        case incrementSlider:
            values?.increment = sender.value
        case decrementSlider:
            values?.decrement = sender.value
        default: break
        }
    }
}
