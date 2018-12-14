//
//  HighscoreViewController.swift
//  Yatodoa
//
//  Created by Alexander Dobrynin on 17.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tagList: [String] = ["#yolo", "#swag", "#einkauf"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = tagList[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    

}
