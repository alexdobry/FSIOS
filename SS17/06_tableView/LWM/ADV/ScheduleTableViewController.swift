//
//  ScheduleTableViewController.swift
//  ADV
//
//  Created by Alex on 14.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {
    
    struct Storyboard {
        static let CellIdentifier = "Schedule Cell Identifier"
        static let SegueIdentifier = "Show Schedule"
    }
    
    var scheduleEntries: [String: [ScheduleEntry]] = [:] {
        didSet { tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CachedWebService.scheduleEntries { result in
            switch result {
            case let .success(entries):
                self.scheduleEntries = entries.groupBy { scheduleEntry -> String in
                    return scheduleEntry.course
                }
                
            case let .failure(e):
                print(e)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleEntries.keys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.CellIdentifier, for: indexPath)
        
        let key = Array(scheduleEntries.keys)[indexPath.row]
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = String(scheduleEntries[key]!.count)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Storyboard.SegueIdentifier:
            guard let detailScheduleVC = segue.destination as? DetailScheduleTableViewController,
                let indexPath = tableView.indexPathForSelectedRow
            else { return }
            
            let key = Array(scheduleEntries.keys)[indexPath.row]
            
            detailScheduleVC.navigationItem.title = key
            detailScheduleVC.allScheduleEntries = scheduleEntries[key]!
        default: break
        }
    }
}
