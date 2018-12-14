//
//  AuthenticationViewController.swift
//  Cryptomarket
//
//  Created by Didi on 30.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIView {

    private var lbl: UILabel!
    private var btn: UIButton!
    
    func openSettings(_ sender: Any) {
        UIApplication.openAppSettings()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    func setupViews() {
        lbl = UILabel(frame: CGRect(x: 0, y: 0, width: window?.bounds.size.width ?? 300, height: window?.bounds.size.height ?? 100))
        btn = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 200))
        
        addSubview(lbl)
        addSubview(btn)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

extension UIApplication {
    class func openAppSettings() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: {enabled in
            // ... handle if enabled
            print("openAppSettings()")
        })
    }
}
