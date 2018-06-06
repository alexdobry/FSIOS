//
//  DetailTodoTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 27.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum ReturnReason {
    case deleted(Todo)
    case updated(Todo)
}

protocol DetailTodoTableViewControllerDelegate {
    func detailVC(_ viewController: DetailTodoTableViewController, returnsWithReason unwindReason: ReturnReason, at indexPath: IndexPath?)
}

class DetailTodoTableViewController: UITableViewController {
    
    private struct Constants {
        static let Formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateStyle = .short
            f.timeStyle = .short
            return f
        }()
        
        static let TagSegue = "TagSelectionSegue"
        static let Sections = 2
    }
    
    var delegate: DetailTodoTableViewControllerDelegate?
    
    var returnReason: ReturnReason?
    
    // MARK: 1. preparation
    var todo: Todo?
    var indexPath: IndexPath?
    
    // MARK: 2. Outlets
    @IBOutlet weak private var tagLabel: UILabel!
    
    private var currentTags: [String] {
        get { return tagLabel.text?.isEmpty ?? true ? [] : tagLabel.text!.components(separatedBy: ", ") }
        set { tagLabel.text = newValue.isEmpty ? nil : newValue.joined(separator: ", ") }
    }
    
    private var favImage: UIImage {
        set { navigationItem.rightBarButtonItems!.last!.image = newValue }
        get { return navigationItem.rightBarButtonItems!.last!.image! }
    }
    
    private var isFavorized: Bool {
        return favImage == #imageLiteral(resourceName: "fav")
    }
    
    private var empty: Bool {
        return todo == nil && indexPath == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let todo = todo else { return }
        
        title = todo.task
        currentTags = todo.tags
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTodo)),
            UIBarButtonItem(image: todo.favorite ? #imageLiteral(resourceName: "fav") : #imageLiteral(resourceName: "unfav"), style: .plain, target: self, action: #selector(favorizeTodo))
        ]
        
        if todo.completed {
            navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int { // handle SplitViewController
        if empty {
            let label = UILabel(frame: tableView.bounds)
            label.backgroundColor = .white
            label.text = "Kein Todo ausgewählt"
            label.textAlignment = .center
            
            tableView.backgroundView = label
            
            return 0
        } else {
            return Constants.Sections
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let finished = todo?.finished, section == 1 {
            return "Erledigt am \(Constants.Formatter.string(from: finished))"
        } else {
            return nil
        }
    }
    
    // MARK: BarButtonItems
    
    @objc func deleteTodo() {
        updateMasterViewController(with: .deleted(todo!))
    }
    
    @objc func favorizeTodo() {
        favImage = favImage == #imageLiteral(resourceName: "fav") ? #imageLiteral(resourceName: "unfav") : #imageLiteral(resourceName: "fav")
        
        todo?.favorite = isFavorized
        updateMasterViewController(with: .updated(todo!))
    }
    
    private func updateMasterViewController(with reason: ReturnReason) {
        returnReason = reason
        delegate?.detailVC(self, returnsWithReason: reason, at: indexPath)
        
        if case .deleted = reason {
            if navigationController?.popViewController(animated: true) == nil { // iPad
                navigationController?.navigationController?.popViewController(animated: true) // iPhone
            }
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Constants.TagSegue:
            guard let destination = segue.destination as? TagsTableViewController else { return }
            
            destination.delegate = self
            destination.selectedTags = currentTags
            
        default: break
        }
    }
}

extension DetailTodoTableViewController: TagsTableViewControllerDelegate {
    
    func tagsViewController(_ viewController: TagsTableViewController, updatedTags tags: [String]) {
        currentTags = tags
        todo?.tags = currentTags
        
        updateMasterViewController(with: .updated(todo!))
    }
}


