//
//  ConnectionViewController.swift
//  Switcheroo
//
//  Created by Dennis Dubbert on 16.05.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController {

    @IBOutlet weak var verbindungen: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    let colorService = ColorServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorService.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        colorService.send(colorName: sender.titleLabel!.text!)
    }

    @IBAction func activate(_ sender: UIButton) {
        self.colorService.start()
        status.text = "Aktiv"
    }
    
    @IBAction func deactivate(_ sender: UIButton) {
        self.colorService.stop()
        status.text = "Inaktiv"
    }
    
    func change(color : UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = color
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConnectionViewController : ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: ColorServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.verbindungen.text = "Verbindungen: \(connectedDevices)"
        }
    }
    
    func colorChanged(manager: ColorServiceManager, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "red":
                self.change(color: .red)
            case "green":
                self.change(color: .green)
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }
    
}
