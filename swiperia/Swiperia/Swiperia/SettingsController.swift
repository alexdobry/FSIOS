//
//  SettingsController.swift
//  Swiperia
//
//  Created by Edgar Gellert on 04.09.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    //MARK: Actions
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "musicOffButton") {
            sender.setImage(#imageLiteral(resourceName: "musicOnButton"), for: .normal)
        } else if sender.currentImage == #imageLiteral(resourceName: "musicOnButton") {
            sender.setImage(#imageLiteral(resourceName: "musicOffButton"), for: .normal)
        }
    }
    
    @IBAction func soundsButtonPressed(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "soundsOffButton") {
            sender.setImage(#imageLiteral(resourceName: "soundsOnButton"), for: .normal)
        } else if sender.currentImage == #imageLiteral(resourceName: "soundsOnButton") {
            sender.setImage(#imageLiteral(resourceName: "soundsOffButton"), for: .normal)
        }
    }
    
    @IBAction func rumbleButtonPressed(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "rumbleOffButton") {
            sender.setImage(#imageLiteral(resourceName: "rumbleOnButton"), for: .normal)
        } else if sender.currentImage == #imageLiteral(resourceName: "rumbleOnButton") {
            sender.setImage(#imageLiteral(resourceName: "rumbleOffButton"), for: .normal)
        }
    }
    
    @IBAction func posColorPickerButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func negColorPickerButtonPressed(_ sender: UIButton) {
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
