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
    func detailVC(_ viewController: DetailTodoTableViewController, returnsWithReason unwindReason: ReturnReason)
}

class DetailTodoTableViewController: UITableViewController {
    
    private struct Constants {
        static let Formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateStyle = .short
            f.timeStyle = .short
            return f
        }()
        
        static let NotesSegue = "NotesSegue"
        static let TagSegue = "TagSelectionSegue"
    }
    
    var delegate: DetailTodoTableViewControllerDelegate?
    
    var returnReason: ReturnReason?
    
    // MARK: 1. preparation
    var todo: ToDo?
    
    // MARK: 2. Outlets
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    // MARK: 3. VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        title = todo?.task
        tagLabel.text = todo?.tag
        notesLabel.text = todo?.notes ?? NotesViewController.Storyboard.TextViewPlaceholder
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTodo)),
            UIBarButtonItem(image: todo!.favorite ? #imageLiteral(resourceName: "fav") : #imageLiteral(resourceName: "unfav"), style: .plain, target: self, action: #selector(favorizeTodo))
        ]
        
        if todo!.completed {
            navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
        }
    }
    
    deinit {
        print(#file, #function)
    }
    
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
    
    @objc func deleteTodo() {
        returnToMasterViewController(with: .deleted(todo!))
    }
    
    var favImage: UIImage {
        set { navigationItem.rightBarButtonItems!.last!.image = newValue }
        get { return navigationItem.rightBarButtonItems!.last!.image! }
    }
    
    @objc func favorizeTodo() {
        favImage = favImage == #imageLiteral(resourceName: "fav") ? #imageLiteral(resourceName: "unfav") : #imageLiteral(resourceName: "fav")
    }
    
    private func returnToMasterViewController(with reason: ReturnReason) {
        returnReason = reason
        delegate?.detailVC(self, returnsWithReason: reason)
        
        if case .deleted = reason {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Constants.NotesSegue:
            guard let dvc = segue.destination.contentViewController as? NotesViewController else { return }
            
            dvc.notes = notesLabel.text
        case Constants.TagSegue: // FIXME: assignment
            guard let destination = segue.destination as? TagsTableViewController else { return }
            
            destination.delegate = self
            destination.selectedTag = tagLabel.text
            
        default: break
        }
    }
    
    @IBAction func unwindFromNotesViewController(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? NotesViewController else { return }
        
        notesLabel.text = svc.notes
    }
}

extension DetailTodoTableViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController is TodoTableViewController, returnReason == nil else { return }
        
        todo?.tag = tagLabel.text
        todo?.notes = notesLabel.text == NotesViewController.Storyboard.TextViewPlaceholder ? nil : notesLabel.text

        let isFavorized = favImage == #imageLiteral(resourceName: "fav")
        
        if todo!.favorite == isFavorized {
            // no changes, update
            returnToMasterViewController(with: .updated(todo!))
        } else {
            todo?.favorite = isFavorized
            
            returnToMasterViewController(with: .favorized(todo!))
        }
    }
}

extension DetailTodoTableViewController: TagsTableViewControllerDelegate {
    func tagsViewController(_ viewController: TagsTableViewController, updatedTag tag: String) {
        tagLabel.text = tag
    }
}
