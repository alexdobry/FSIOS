//
//  TagTableViewController.swift
//  Yatodoa
//
//  Created by Uwe Müsse on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum TagType {
    case add, created
}

extension TagType {
    
    init(tag: Tag) {
        self = tag.isEmpty ? .add : .created
    }
    
    var headerTitle: String {
        switch self {
        case .add: return "Hinzufügen"
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


var TAGS: [Tag] = []


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
    
    var selectedTag: String?
    
    var tagsSections: [(key: TagType, value: [Tag])] = []
    
    var delegate : DetailTodoTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: AddItemTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: AddItemTableViewCell.ReuseIdentifier)

        if (TAGS.isEmpty) {
            TAGS.append(Tag.empty)
            TAGS.append(Tag.defaultTag)
        }
        tags.append(contentsOf: TAGS)

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tagsSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsSections[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (section, _) = tagsSections[indexPath.section]
        
        switch section {
        case .add:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTableViewCell.ReuseIdentifier, for: indexPath) as! AddItemTableViewCell
            cell.delegate = self
            cell.accessoryType = .none
            
            return cell
        case .created:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagReuseIdentifier", for: indexPath)
            cell.textLabel?.text = tagsSections[indexPath.section].value[indexPath.row].label
            cell.textLabel?.textColor = tagsSections[indexPath.section].value[indexPath.row].color
            if let selectedTag = selectedTag, selectedTag == cell.textLabel?.text {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tagsSections[section].key.headerTitle
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (section, _) = tagsSections[indexPath.section]
        
        if(section == .created){
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            
            let tag = tagsSections.first { (k, v) -> Bool in
                return k == .created
            }?.value.filter({ (tag) -> Bool in
                return tag.label == cell?.textLabel?.text
            }).first
            
            selectedTag = tag?.label
            
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tag = tagsSections.first { (k, v) -> Bool in
            return k == .created
            }?.value.filter({ (tag) -> Bool in
                return tag.label == selectedTag
            }).first
        delegate?.ttvc(self, selectedTag: tag )
    }
    
    // MARK: - private helper
    
    private func insert(_ tag: Tag, animated: Bool) {

        TAGS.append(tag)

        if animated {
            let section = TagType.created
            let sectionsExists = tagsSections.contains(where: { $0.key == section }) // before we append
            tags.append(tag)
            
            let nextPos = tagsSections.first(where: { $0.key == section })!.value.count - 1 // after we append
            
            let indexPath = IndexPath(row: nextPos, section: section.hashValue)
            
            if sectionsExists {
                tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
                tableView.beginUpdates()
                tableView.insertSections(IndexSet(integer: section.hashValue), with: .automatic)
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        } else {
            tags.append(tag)
            tableView.reloadData()
        }

    }

}

extension TagTableViewController : AddItemTableViewCellDelegate {
    func addItemCell(_ cell: AddItemTableViewCell, didCreateItem string: String?) {
        guard let string = string, !string.isEmpty else { return }
        
        insert(Tag(label: string), animated: true)
        

        cell.textField.text = nil
    }
}
