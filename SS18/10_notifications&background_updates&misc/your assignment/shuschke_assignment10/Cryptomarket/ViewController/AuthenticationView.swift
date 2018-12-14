//
//  AuthenticationViewController.swift
//  Cryptomarket
//
//  Created by Didi on 30.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class AuthenticationView: UIView {
    
    private var lbl: UILabel!
    private var btn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        lbl = UILabel(frame: CGRect(x: 50, y: 0, width: window?.bounds.size.width ?? 450, height: window?.bounds.size.height ?? 100))
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        
        btn = UIButton(frame: CGRect(x: 50, y: 100, width: 200, height: 50))
        btn.setTitle("Yes, open Setting", for: .normal)
        btn.backgroundColor = UIColor.cyan
        btn.addTarget(self, action: #selector(openAppSettings), for: .touchUpInside)
        
        
        lbl.text = "Enable Notificationsettings in order to continue"
        
        addSubview(lbl)
        addSubview(btn)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @objc func openAppSettings() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
}

extension UIApplication {
    func openAppSettings() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
}


