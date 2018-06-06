//
//  TodoTableViewController.swift
//  Done
//
//  Created by Alex on 26.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    private struct Storyboard {
        static let DetailSegueIdentifier = "DetailSegueIdentifier"
    }
    
    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: TodoTableViewCell.NibName, bundle: nil),
            forCellReuseIdentifier: TodoTableViewCell.ReuseIdentifier
        )
        
        let addTodoView: AddTodoView = {
            let view = AddTodoView()
            let height = view.preferedHeight
            
            view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: height)
            view.delegate = self
            
            return view
        }()
        
        tableView.tableHeaderView = addTodoView
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.ReuseIdentifier, for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        
        cell.delegate = self
        cell.todo = todo.task
        cell.completed = todo.completed
        cell.tags = todo.tags
        cell.favorized = todo.favorite
        
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
            let dest = segue.contentViewController as! DetailTodoTableViewController
            let indexPath = sender as! IndexPath
            
            dest.todo = todos[indexPath.row]
            dest.indexPath = indexPath
            dest.delegate = self
            
        default: break
        }
    }
    
    private func createTodo(with text: String) {
        let todo = Todo(task: text)
        todos.append(todo) // update model
        
        let indexPath = IndexPath(row: todos.count - 1, section: tableView.numberOfSections - 1)
        tableView.insertRows(at: [indexPath], with: .automatic) // update UI
    }
    
    private func deleteTodo(at indexPath: IndexPath) {
        todos.remove(at: indexPath.row) // update model
        tableView.deleteRows(at: [indexPath], with: .automatic) // update UI
    }
}

extension TodoTableViewController: TodoTableViewCellDelegate {
    
    func todoCell(_ cell: TodoTableViewCell, wasCompleted completed: Bool) {
        let indexPath = tableView.indexPath(for: cell)!
        todos[indexPath.row].completed = completed // update model
        tableView.reloadRows(at: [indexPath], with: .automatic) // update UI
    }
    
    func todoCell(_ cell: TodoTableViewCell, updatedTodo task: String) {
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
        case .updated(let newTodo): // assignment
            todos[indexPath!.row] = newTodo // update model
            tableView.reloadRows(at: [indexPath!], with: .automatic) // update UI
        }
    }
}

extension TodoTableViewController: AddTodoViewDelegate {
    
    func addTodoView(_ view: AddTodoView, didCreateTodo task: String) {
        createTodo(with: task)
    }
}
