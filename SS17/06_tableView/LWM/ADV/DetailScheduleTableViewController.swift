//
//  DetailScheduleTableViewController.swift
//  ADV
//
//  Created by Alex on 14.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class DetailScheduleTableViewController: UITableViewController {
    
    private struct Storyboard {
        static let FilterSelectionIdentifer = "Select Filter"
    }
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        return f
    }()
    
    var allScheduleEntries: [ScheduleEntry] = []
    var currentFilter = ScheduleEntryFilter(rawValue: Storage.currentFilter)!
    
    private var groupedScheduleEntries: [(key: Date, value: [ScheduleEntry])] = [] {
        didSet { tableView.reloadData() }
    }
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(filterSelectionDidChange), name: Storage.CurrentFilterNotificationName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        groupedScheduleEntries = allScheduleEntries.filter { entry in
            currentFilter.filterPredicate(entry)
        }.sorted { (l, r) in
            return l.start < r.start
        }.groupBy { scheduleEntry -> Date in
            return scheduleEntry.date
        }.sorted { (l, r) in
            return l.key < r.key
        }
    }
    
    // MARK: - Notfication
    
    @objc func filterSelectionDidChange(sender: Notification) {
        guard let filterIndex = sender.object as? Int,
            let filter = ScheduleEntryFilter(rawValue: filterIndex)
            else { return }
        
        currentFilter = filter
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedScheduleEntries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedScheduleEntries[section].value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleEntryTableViewCell.CellIdentifier, for: indexPath) as! ScheduleEntryTableViewCell

        cell.scheduleEntry = groupedScheduleEntries[indexPath.section].value[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formatter.string(from: groupedScheduleEntries[section].key)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifer = segue.identifier else { return }
        
        switch identifer {
        case Storyboard.FilterSelectionIdentifer:
            guard let filterSelectionVC = segue.contentViewController as? FilterSelectionTableViewController else { return }
            
            filterSelectionVC.currentFilter = currentFilter.rawValue
        default: break
        }
    }
}
