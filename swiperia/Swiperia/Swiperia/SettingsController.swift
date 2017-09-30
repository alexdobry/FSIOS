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
            //posColorPickerButton.backgroundImage(for: .normal) = processPixels(in: #imageLiteral(resourceName: "colorPickerButton"), to: RGBA32(red: positiveColor.g, green: <#T##UnsafeMutablePointer<CGFloat>?#>, blue: <#T##UnsafeMutablePointer<CGFloat>?#>, alpha: <#T##UnsafeMutablePointer<CGFloat>?#>), green: <#T##UInt8#>, blue: <#T##UInt8#>, alpha: <#T##UInt8#>))
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
                if pixelBuffer[offset] == .white {
                    pixelBuffer[offset] = color
                }
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }
    
    struct RGBA32: Equatable {
        private var color: UInt32
        
        var redComponent: UInt8 {
            return UInt8((color >> 24) & 255)
        }
        
        var greenComponent: UInt8 {
            return UInt8((color >> 16) & 255)
        }
        
        var blueComponent: UInt8 {
            return UInt8((color >> 8) & 255)
        }
        
        var alphaComponent: UInt8 {
            return UInt8((color >> 0) & 255)
        }
        
        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            color = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | (UInt32(alpha) << 0)
        }
        
        static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
        static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
        static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
        static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
        static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
        static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
        static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
        static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
}
