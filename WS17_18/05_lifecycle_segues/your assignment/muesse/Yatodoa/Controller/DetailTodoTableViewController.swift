//
//  DetailTodoTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 28.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol DetailTodoTableViewControllerDelegate {
    func dvc(_ vc: DetailTodoTableViewController, updatedTodo todo: ToDo)
}

class DetailTodoTableViewController: UITableViewController {
    
    private struct Storyboard {
        static let SegueIdentifier = "NotesSegueIdentifier"
    }
    
    private struct Constants {
        static let Formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateStyle = .short
            f.timeStyle = .short
            return f
        }()
        
        static let NotesDefaultText = "Notiz..."
    }
    
    // MARK: 1. Preparation
    var todo: ToDo?
    
    var delegate: DetailTodoTableViewControllerDelegate?
    
    // MARK: 2. Outlets
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    // MARK: 3. VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = todo!.task
        tagLabel.text = todo!.tag?.label
        notesLabel.text = todo!.notes ?? Constants.NotesDefaultText
        
        navigationController?.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 1 && todo!.completed ? "Erledigt am \(Constants.Formatter.string(from: todo!.finished!))" : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - navigation
    
    @IBAction func unwindFromNotesVC(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? NotesViewController else { return }
        
        notesLabel.text = svc.notes
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Storyboard.SegueIdentifier:
            guard let dvc = segue.destination.contentViewController as? NotesViewController else { return }
            
            dvc.notes = notesLabel.text
        case "TagSegueIdentifier":
            guard let dvc = segue.destination.contentViewController as? TagTableViewController else { return }
            dvc.delegate = self
            dvc.selectedTag = tagLabel.text
        default: return
        }
    }
}

extension DetailTodoTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController is TodoTableViewController else { return }
        
        todo?.notes = notesLabel.text == Constants.NotesDefaultText ? nil : notesLabel.text
        
        delegate?.dvc(self, updatedTodo: todo!)
    }
}

extension DetailTodoTableViewController: TagTableViewControllerDelegate {
    
    func ttvc(_ vc: TagTableViewController, selectedTag tag: Tag?) {
        todo?.tag = tag
        tagLabel.text = tag?.label
    }
    
}
