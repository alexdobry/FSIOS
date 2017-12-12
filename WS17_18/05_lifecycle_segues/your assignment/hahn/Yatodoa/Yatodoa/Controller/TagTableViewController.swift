//
//  TagTableViewController.swift
//  Yatodoa
//
//  Created by Christian Hahn on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

let Tags = ["pork", "chop", "pastrami", "ball", "tip", "meatloaf", "ribeye", "tenderloin", "hamburger", "biltong", "bacon", "jowl", "strip", "steak", "kielbasa"].map { string in
    Tag(label: string)
}


enum TagType {
    case created
}

extension TagType {
    
    init(tag: Tag) {
        self = .created
    }
    
    var headerTitle: String {
        switch self {
            case .created: return "Tags"
        }
    }
    
    static func < (lhs: TagType, rhs: TagType) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
}

protocol TagTableViewControllerDelegate {
    func ttvc(_ vc: TagTableViewController, selectedTag tag: Tag?)
}

class TagTableViewController: UITableViewController {
    
    var tags: [Tag] = [] {
        didSet {
            print(tags)
            
            tagsSections = tags.groupBy(key: { tag in
                return TagType(tag: tag)
            }).sorted { (l, r) -> Bool in
                return l.key < r.key
            }
        }
    }
    
    var tagsSections: [(key: TagType, value: [Tag])] = []
    
    var delegate: TagTableViewControllerDelegate?
    
    var selectedTag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tags.append(contentsOf: Tags)
    }
    
    private func populate(_ n: Int, tagNames: [String]) {
        (0..<n).forEach { _ in // populate data
            let randomIndex = Int(arc4random_uniform(UInt32(tagNames.count)))
            tags.append(Tag(label: tagNames[randomIndex]))
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tagsSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsSections[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        selectedTag = cell?.textLabel?.text
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // delegate aufrufen
        let tag = tags.filter { (tag) -> Bool in
            return tag.label == selectedTag
        }.first
        
        delegate?.ttvc(self, selectedTag: tag)
        print("viewWillDisappear")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = tags[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = tag.label
        cell.textLabel?.textColor = tag.color
        
        if let selectedTag = selectedTag, tag.label == selectedTag {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tagsSections[section].key.headerTitle
    }

}
