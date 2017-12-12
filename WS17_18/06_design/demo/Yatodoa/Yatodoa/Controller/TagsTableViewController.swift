//
//  TagsTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol TagsTableViewControllerDelegate {
    func tagsViewController(_ viewController: TagsTableViewController, updatedTag tag: String)
}

class TagsTableViewController: UITableViewController {
    
    // MARK: public api
    var selectedTag: String?
    
    var delegate: TagsTableViewControllerDelegate?
    
    private var tags: [Tag] = [] {
        didSet {
            tagSections = tags.groupBy { tag in
                return TagType(by: tag)
            }.sorted { (l, r) in
                return l.key < r.key
            }
        }
    }
    
    private var tagSections: [(key: TagType, value: [Tag])] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var lastCheckmark: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Taggen"
        
        tableView.register(UINib(nibName: AddItemTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: AddItemTableViewCell.ReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tags.append(contentsOf: [Tag.empty] + Tag.all)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tagSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagSections[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tagSections[indexPath.section].key {
        case .add:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTableViewCell.ReuseIdentifier, for: indexPath) as! AddItemTableViewCell
            cell.placeholder = "dein tag..."
            cell.delegate = self
            
            return cell
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagCellReuseIdentifier", for: indexPath)
            let current = tagSections[indexPath.section].value[indexPath.row]
            
            cell.textLabel?.text = current.title
            cell.textLabel?.textColor = current.color
            
            if let selected = selectedTag, selected == current.title {
                lastCheckmark = indexPath
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tagSections[section].key.headerTitle
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == TagType.list.hashValue
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedTag = tagSections[indexPath.section].value[indexPath.row].title
        
        delegate!.tagsViewController(self, updatedTag: selectedTag!)
        
        if let lastCheckmark = lastCheckmark {
            tableView.reloadRows(at: [indexPath, lastCheckmark], with: .automatic)
        } else {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension TagsTableViewController: AddItemTableViewCellDelegate {
    
    func addItemCell(_ cell: AddItemTableViewCell, didCreateItem string: String?) {
        guard let string = string, !string.isEmpty, !tags.contains(where: { $0.title == string }) else { return }
        
        let tag = Tag(title: string)
        
        tags.append(tag)
        Tag.all.append(tag)
    }
}
