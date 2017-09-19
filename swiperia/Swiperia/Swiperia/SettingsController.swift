//
//  SettingsController.swift
//  Swiperia
//
//  Created by Edgar Gellert on 04.09.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import UIKit
import ChromaColorPicker

class SettingsController: UIViewController, ChromaColorPickerDelegate {
    
    //MARK: Properties
    var positiveColor : UIColor = .orange //temporär
    var negativeColor : UIColor = .red //temporär
    var activeColorPicker : String?
    
    var subView : UIView?
    
    let languages = ["English", "German", "Klingon", "Calamari"]
    var pickedLanguage : String?
    
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var soundsButton: UIButton!
    @IBOutlet weak var rumbleButton: UIButton!
    @IBOutlet weak var languagePickerButton: UIButton!
    @IBOutlet weak var posColorPickerButton: UIButton!
    @IBOutlet weak var negColorPickerButton: UIButton!
    @IBOutlet weak var settingsView: UIView!
    
    
    //MARK: Language Picker
    
    let alert = UIAlertController(title: "Languages", message: "Choose a language!", preferredStyle: .actionSheet)
    
    
    
    //MARK: Actions
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "musicOffButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "musicOnButton"), for: .normal)
        } else if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "musicOnButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "musicOffButton"), for: .normal)
        }
    }
    
    @IBAction func soundsButtonPressed(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "soundsOffButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "soundsOnButton"), for: .normal)
        } else if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "soundsOnButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "soundsOffButton"), for: .normal)
        }
    }
    
    @IBAction func rumbleButtonPressed(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "rumbleOffButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "rumbleOnButton"), for: .normal)
        } else if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "rumbleOnButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "rumbleOffButton"), for: .normal)
        }
    }
    
    @IBAction func languagePickerButtonPressed(_ sender: UIButton) {
        showLanguageView()
    }
    
    
    @IBAction func posColorPickerButtonPressed(_ sender: UIButton) {
        activeColorPicker = "positive"
        openColorPicker()
    }
    
    
    
    @IBAction func negColorPickerButtonPressed(_ sender: UIButton) {
        activeColorPicker = "negative"
        openColorPicker()
    }
    
    
    //    MARK: Functions
    
    // Funktion zum Speichern der Farbe aus dem ColorPicker
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        guard let activeColorPicker = activeColorPicker else { return }
        switch activeColorPicker {
        case "positive":
            positiveColor = color
            colorPicker.removeFromSuperview()
            subView?.removeFromSuperview()
        case "negative":
            negativeColor = color
            colorPicker.removeFromSuperview()
            subView?.removeFromSuperview()
        default:
            print("error")
        }
        
    }
    
    // Funktion öffnet einen ColorPicker zur Auswahl einer Farbe
    func openColorPicker() {
        subView = UIView(frame: settingsView.frame)
        subView!.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        
        let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.width * 0.8))
        neatColorPicker.delegate = self //ChromaColorPickerDelegate
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.white
        
        subView!.addSubview(neatColorPicker)
        settingsView.addSubview(subView!)
        subView!.center = settingsView.center
        neatColorPicker.center = settingsView.center
    }
    
    // Show language action sheet
    func showLanguageView() {
        let alert = UIAlertController(title: "Languages", message: "Choose a language", preferredStyle: .actionSheet)
        
        let cancelActoin = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelActoin)
        
        languages
            .map{ UIAlertAction(title: $0, style: .default) {
                self.pickedLanguage = $0.title
                print(self.pickedLanguage!) // Hier Code für Sprachänderung einfügen
                // Aktualisieren des Buttonlabels mit der gewählten Sprache.
                self.languagePickerButton.titleLabel?.text = self.pickedLanguage
                } }
            .forEach{alert.addAction($0)}
        present(alert, animated: true, completion: nil)
    }
    
    // Initiate Buttons
    func initiateButtons() {
        for view in buttonStackView.arrangedSubviews {
            if let button = view as? UIButton {
                button.contentHorizontalAlignment = .left
                button.titleEdgeInsets.left = 15
            }
        }
    }
    
    // MARK: System-Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}




