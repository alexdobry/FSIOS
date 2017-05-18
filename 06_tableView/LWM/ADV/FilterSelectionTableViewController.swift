//
//  FilterSelectionTableViewController.swift
//  ADV
//
//  Created by Alex on 16.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum ScheduleEntryFilter: Int {
    case upcoming = 0
    case none = 1
}

extension ScheduleEntryFilter {
    
    var filterPredicate: (ScheduleEntry) -> Bool {
        switch self {
        case .upcoming:
            return { entry in return entry.date >= Date() }
        case .none:
            return { _ in return true }
        }
    }
}

class FilterSelectionTableViewController: UITableViewController {
    
    var currentFilter: Int?
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let currentFilter = currentFilter else { return }
        
        if indexPath.row == currentFilter {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        currentFilter = indexPath.row
        
        tableView.reloadData()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        Storage.currentFilter = currentFilter!
        
        cancel(sender)
    }
}
