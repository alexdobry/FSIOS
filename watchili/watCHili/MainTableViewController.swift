//
//  MainTableViewController.swift
//  watCHili
//
//  Created by Uwe Müsse on 16.05.17.
//  Copyright © 2017 watchili. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            cell.textLabel?.text = "penis"
        }
        
        if indexPath.section == 1 {
            cell.textLabel?.text = "31°"
            cell.detailTextLabel?.text = "33°"
        }
    }
}
