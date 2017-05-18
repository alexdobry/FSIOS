//
//  LoginViewController.swift
//  ADV
//
//  Created by Alex on 14.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField! { didSet { usernameTextField.delegate = self } }
    @IBOutlet weak var passwordTextField: UITextField! { didSet { passwordTextField.delegate = self } }
    @IBOutlet weak var loginButton: UIButton! { didSet { loginButton.isEnabled = false } }
    
    @IBAction func login(_ sender: UIButton) {
        WebService.login(username: usernameTextField.text!, password: passwordTextField.text!) { result in
            switch result {
            case let .success(cookie):
                Storage.cookie = cookie
                
                self.performSegue(withIdentifier: "Show Main Controller", sender: nil)
            case let .failure(e):
                print(e.localizedDescription)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty && !password.isEmpty {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
}
