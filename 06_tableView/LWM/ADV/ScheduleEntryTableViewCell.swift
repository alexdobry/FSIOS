//
//  ScheduleEntryTableViewCell.swift
//  ADV
//
//  Created by Alex on 14.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ScheduleEntryTableViewCell: UITableViewCell {
    
    static let CellIdentifier = "ScheduleEntry Cell Identifier"
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    @IBOutlet weak var timeInRoomLabel: UILabel!
    @IBOutlet weak var degreeAndGroupLabel: UILabel!
    
    var scheduleEntry: ScheduleEntry? {
        didSet { updateUI() }
    }
    
    private func updateUI() {
        guard let entry = scheduleEntry else { return }
        
        preservesSuperviewLayoutMargins = true
        contentView.preservesSuperviewLayoutMargins = true
        
        timeInRoomLabel.text = String(
            format: "%@-%@ Uhr in Raum %@",
            formatter.string(from: entry.start),
            formatter.string(from: entry.end),
            entry.room
        )
        
        degreeAndGroupLabel.text = String(format: "%@ Gruppe %@", entry.degree, entry.group)
    }
    
    override func prepareForReuse() {
        timeInRoomLabel.text = nil
        degreeAndGroupLabel.text = nil
    }
}
