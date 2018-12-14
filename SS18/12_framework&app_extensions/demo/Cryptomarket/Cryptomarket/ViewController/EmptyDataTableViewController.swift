
//
//  EmptyDataTableViewController.swift
//  Cryptomarket
//
//  Created by Alex on 23.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

// "empty data screen" from http://www.benmeline.com/ios-empty-table-view-with-swift/

protocol EmptyDataTableViewDataSource: class {
    var headline: String { get }
    var content: String { get }
    var isEmpty: Bool { get }
    
    var numberOfSections: Int { get }
    var emptyScreenTapped: (() -> Void)? { get }
}

class EmptyDataTableViewController: UITableViewController {
    
    weak var emptyDataDataSource: EmptyDataTableViewDataSource?
    
    private var isEmpty: Bool {
        return emptyDataDataSource?.isEmpty ?? false
    }
    
    private var numberOfSections: Int {
        return emptyDataDataSource?.numberOfSections ?? 1
    }
    
    private var headline: String {
        return emptyDataDataSource?.headline ?? "Empty Data"
    }
    
    private var content: String {
        return emptyDataDataSource?.content ?? "Nothing to show"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isEmpty {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            
            let title = NSAttributedString(string: headline, attributes:
                [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .title1), NSAttributedStringKey.foregroundColor: UIColor.black]
            )
            
            let body = NSAttributedString(string: content, attributes:
                [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .title2), NSAttributedStringKey.foregroundColor: UIColor.blue]
            )
            
            let mutable = NSMutableAttributedString()
            mutable.append(title)
            mutable.append(body)
            
            noDataLabel.attributedText = mutable
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            
            if emptyDataDataSource?.emptyScreenTapped != nil {
                noDataLabel.isUserInteractionEnabled = true // clickable
                noDataLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emptyScreenTapped))) // callback
            }
            
            tableView.backgroundView = noDataLabel
            tableView.tableHeaderView = nil
            tableView.separatorStyle = .none // disable lines
            
            return 0
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine // enable lines
            
            return numberOfSections
        }
    }
    
    @objc func emptyScreenTapped() { // send user to settings vc
        emptyDataDataSource?.emptyScreenTapped?()
    }
}
