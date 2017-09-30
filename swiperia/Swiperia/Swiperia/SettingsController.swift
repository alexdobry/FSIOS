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
    
    //MARK: - UserDefaults AppDelegate
    
    
    //MARK: - Properties
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
    
    
    //MARK: - Language Picker
    
    let alert = UIAlertController(title: "Languages", message: "Choose a language!", preferredStyle: .actionSheet)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let music = (UIApplication.shared.delegate as! AppDelegate).settings["music"] as! Bool
        if music {
            musicButton.setBackgroundImage(#imageLiteral(resourceName: "musicOnButton"), for: .normal)
        } else {
            musicButton.setBackgroundImage(#imageLiteral(resourceName: "musicOffButton"), for: .normal)
        }
        
        let sounds = (UIApplication.shared.delegate as! AppDelegate).settings["sounds"] as! Bool
        if sounds {
            soundsButton.setBackgroundImage(#imageLiteral(resourceName: "soundsOnButton"), for: .normal)
        } else {
            soundsButton.setBackgroundImage(#imageLiteral(resourceName: "soundsOffButton"), for: .normal)
        }
        
        let rumble = (UIApplication.shared.delegate as! AppDelegate).settings["rumble"] as! Bool
        if rumble {
            rumbleButton.setBackgroundImage(#imageLiteral(resourceName: "rumbleOnButton"), for: .normal)
        } else {
            rumbleButton.setBackgroundImage(#imageLiteral(resourceName: "rumbleOffButton"), for: .normal)
        }
        
        languagePickerButton.setTitle(((UIApplication.shared.delegate as! AppDelegate).settings["language"] as! String), for: .normal)
        
        if let oldPosColor = ((UIApplication.shared.delegate as! AppDelegate).settings["posColor"] as! UIColor).toRGBA32() {
            posColorPickerButton.setBackgroundImage(processPixels(in: #imageLiteral(resourceName: "colorPickerButton"), to: oldPosColor), for: .normal)
        }
        
        if let oldNegColor = ((UIApplication.shared.delegate as! AppDelegate).settings["negColor"] as! UIColor).toRGBA32() {
            negColorPickerButton.setBackgroundImage(processPixels(in: #imageLiteral(resourceName: "colorPickerButton"), to: oldNegColor), for: .normal)
        }
    }
    
    //MARK: - Actions
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "musicOffButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "musicOnButton"), for: .normal)
            (UIApplication.shared.delegate as! AppDelegate).settings["music"] = true
        } else if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "musicOnButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "musicOffButton"), for: .normal)
            (UIApplication.shared.delegate as! AppDelegate).settings["music"] = false
        }
    }
    
    @IBAction func soundsButtonPressed(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "soundsOffButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "soundsOnButton"), for: .normal)
            (UIApplication.shared.delegate as! AppDelegate).settings["sounds"] = true
        } else if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "soundsOnButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "soundsOffButton"), for: .normal)
            (UIApplication.shared.delegate as! AppDelegate).settings["sounds"] = false
        }
    }
    
    @IBAction func rumbleButtonPressed(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "rumbleOffButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "rumbleOnButton"), for: .normal)
            (UIApplication.shared.delegate as! AppDelegate).settings["rumble"] = true
        } else if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "rumbleOnButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "rumbleOffButton"), for: .normal)
            (UIApplication.shared.delegate as! AppDelegate).settings["rumble"] = false
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
    
    
    //MARK: - Functions
    
    // Funktion zum Speichern der Farbe aus dem ColorPicker
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        guard let activeColorPicker = activeColorPicker else { return }
        switch activeColorPicker {
        case "positive":
            positiveColor = color
            colorPicker.removeFromSuperview()
            subView?.removeFromSuperview()
            (UIApplication.shared.delegate as! AppDelegate).settings["posColor"] = positiveColor
            if let newColor = positiveColor.toRGBA32() {
                posColorPickerButton.setBackgroundImage(processPixels(in: #imageLiteral(resourceName: "colorPickerButton"), to: newColor), for: .normal)
            }
        case "negative":
            negativeColor = color
            colorPicker.removeFromSuperview()
            subView?.removeFromSuperview()
            (UIApplication.shared.delegate as! AppDelegate).settings["negColor"] = positiveColor
            if let newColor = negativeColor.toRGBA32() {
                negColorPickerButton.setBackgroundImage(processPixels(in: #imageLiteral(resourceName: "colorPickerButton"), to: newColor), for: .normal)
            }
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
                self.languagePickerButton.titleLabel?.text = self.pickedLanguage
                (UIApplication.shared.delegate as! AppDelegate).settings["language"] = self.pickedLanguage
                }
            }
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
    
    // MARK: - System-Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processPixels(in image: UIImage, to color: RGBA32) -> UIImage? {
        guard let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if pixelBuffer[offset] >= RGBA32.init(red: 100, green: 100, blue: 100, alpha: 255) {
                    pixelBuffer[offset] = color
                }
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }
}
