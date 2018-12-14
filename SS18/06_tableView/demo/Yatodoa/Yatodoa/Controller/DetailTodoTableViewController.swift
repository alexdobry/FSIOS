//
//  DetailTodoTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 27.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum ReturnReason {
    case favorized(ToDo)
    case deleted(ToDo)
    case updated(ToDo)
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
    }
    
    var delegate: DetailTodoTableViewControllerDelegate?
    
    var returnReason: ReturnReason?
    
    // MARK: 1. preparation
    var todo: ToDo?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(todo != nil && indexPath != nil, "todo must be set")
        
        navigationController?.delegate = self
        
        title = todo?.task
        currentTags = todo?.tags ?? []
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTodo)),
            UIBarButtonItem(image: todo!.favorite ? #imageLiteral(resourceName: "fav") : #imageLiteral(resourceName: "unfav"), style: .plain, target: self, action: #selector(favorizeTodo))
        ]
        
        if todo!.completed {
            navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // performSegue(withIdentifier: "TagsTableViewController", sender: indexPath) // FIXME: assignment
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
        returnToMasterViewController(with: .deleted(todo!))
    }
    
    @objc func favorizeTodo() {
        favImage = favImage == #imageLiteral(resourceName: "fav") ? #imageLiteral(resourceName: "unfav") : #imageLiteral(resourceName: "fav")
    }
    
    private func returnToMasterViewController(with reason: ReturnReason) {
        returnReason = reason
        delegate?.detailVC(self, returnsWithReason: reason, at: indexPath)
        
        if case .deleted = reason {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension DetailTodoTableViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController is TodoTableViewController, returnReason == nil else { return }

        if todo!.favorite == isFavorized { // no changes, update
            returnToMasterViewController(with: .updated(todo!))
        } else {
            todo?.favorite = isFavorized
            returnToMasterViewController(with: .favorized(todo!))
        }
    }
}
