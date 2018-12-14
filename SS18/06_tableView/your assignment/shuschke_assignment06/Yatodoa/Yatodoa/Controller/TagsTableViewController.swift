//
//  TagsTableViewController.swift
//  Yatodoa
//
//  Created by Alexander Dobrynin on 17.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class TagsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tagList: [String] = ["#yolo", "#swag", "#einkauf"]
    
    enum Auswahl {
        case none
        case checkmark
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = tagList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
