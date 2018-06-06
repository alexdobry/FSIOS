//
//  TagsTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol TagsTableViewControllerDelegate {
    func tagsViewController(_ viewController: TagsTableViewController, updatedTags tags: [String])
}

class TagsTableViewController: UITableViewController {
    
    // MARK: public api
    var selectedTags: [String] = []
    
    var delegate: TagsTableViewControllerDelegate?
    
    var tags: [Tag] = Tag.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Taggen"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCellReuseIdentifier", for: indexPath)
        let tag = tags[indexPath.row]
        
        cell.textLabel?.text = tag.title
        cell.textLabel?.textColor = tag.color
        
        if selectedTags.contains(tag.title) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selected = tags[indexPath.row]
        
        if let index = selectedTags.index(of: selected.title) { // deselect
            selectedTags.remove(at: index)
        } else { // select
            selectedTags.append(selected.title)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        delegate?.tagsViewController(self, updatedTags: selectedTags)
    }
}
