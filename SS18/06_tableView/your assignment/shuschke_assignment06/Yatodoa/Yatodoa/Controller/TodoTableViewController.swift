//
//  TodoTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 23.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    private struct Storyboard {
        static let DetailSegueIdentifier = "DetailSegueIdentifier"
    }
    
    var todos: [ToDo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: ToDoTableViewCell.NibName, bundle: nil),
            forCellReuseIdentifier: ToDoTableViewCell.ReuseIdentifier
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTodo)
        )
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.ReuseIdentifier, for: indexPath) as! ToDoTableViewCell
        let todo = todos[indexPath.row]
        
        cell.delegate = self
        cell.todo = todo.task
        cell.completed = todo.completed
        cell.tags = todo.tags
        
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    // MARK: UITableVIewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return todos[indexPath.row].completed ? .none : .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteTodo(at: indexPath)
        case .insert, .none: break
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.DetailSegueIdentifier, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indentifier = segue.identifier else { return }
        
        switch indentifier {
        case Storyboard.DetailSegueIdentifier:
            let dest = segue.destination as! DetailTodoTableViewController
            let indexPath = sender as! IndexPath
            
            dest.todo = todos[indexPath.row]
            dest.indexPath = indexPath
            dest.delegate = self
            
        default: break
        }
    }
    
    @objc func addTodo() {
        let alert = UIAlertController(title: "New Todo", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "your todo ..."
        }
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self.createTodo(with: text)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func createTodo(with text: String) {
        let todo = ToDo(task: text)
        todos.append(todo) // update model
        
        let indexPath = IndexPath(row: todos.count - 1, section: tableView.numberOfSections - 1)
        tableView.insertRows(at: [indexPath], with: .automatic) // update UI
    }
    
    private func deleteTodo(at indexPath: IndexPath) {
        todos.remove(at: indexPath.row) // update model
        tableView.deleteRows(at: [indexPath], with: .automatic) // update UI
    }
}

extension TodoTableViewController: ToDoTableViewCellDelegate {
    
    func todoCell(_ cell: ToDoTableViewCell, wasCompleted completed: Bool) {
        let indexPath = tableView.indexPath(for: cell)!
        todos[indexPath.row].completed = completed // update model
        tableView.reloadRows(at: [indexPath], with: .automatic) // update UI
    }
    
    func todoCell(_ cell: ToDoTableViewCell, updatedTodo task: String) {
        let indexPath = tableView.indexPath(for: cell)!
        todos[indexPath.row].task = task // update model
        tableView.reloadRows(at: [indexPath], with: .automatic) // update UI
    }
}

extension TodoTableViewController: DetailTodoTableViewControllerDelegate {
    func detailVC(_ viewController: DetailTodoTableViewController, returnsWithReason unwindReason: ReturnReason, at indexPath: IndexPath?) {
        print(unwindReason)
        
        switch unwindReason {
        case .deleted:
            deleteTodo(at: indexPath!)
        case .favorized: break // later
        case .updated(let newTodo): // assignment
            todos[indexPath!.row].tags = newTodo.tags // update model
            tableView.reloadRows(at: [indexPath!], with: .automatic) // update UI
        }
    }
}
