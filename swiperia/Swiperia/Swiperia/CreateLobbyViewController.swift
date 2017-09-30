//
//  CreateLobbyControler.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 06.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit

class CreateLobbyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderNumber: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var textFieldPW: UITextField!
    
    var game : Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldPW.delegate = self

        createButton.backgroundColor = .clear
        createButton.setBackgroundImage(#imageLiteral(resourceName: "highButtonBlack"), for: .normal)
        
        slider.addTarget(self, action: #selector(sliderUpdate), for: .valueChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }
    
    func sliderUpdate() {
        let roundedValue = round(slider.value)
        slider.value = roundedValue
        sliderNumber.text = "\(Int(roundedValue))"
    }
    
    func dismissKeyboard() {
        textFieldPW.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if notification.name == Notification.Name.UIKeyboardWillHide {
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
                return
            }
            
            if let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.transform = CGAffineTransform(translationX: 0, y: -(endFrame.height - createButton.frame.height - 32))
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HostLobbySegue" {
            if let toViewController = segue.destination as? MultipeerLobbyViewController {
                toViewController.password = textFieldPW.text
                toViewController.isHost = true
                toViewController.maxMember = Int(slider.value)
                toViewController.game = game
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.tabBarController?.setTabBarVisible(visible: true, duration: 0.3, animated: true)
    }
}
