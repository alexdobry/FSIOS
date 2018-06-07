//
//  TodoTableViewController.swift
//  Done
//
//  Created by Alex on 26.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: NSFetchedResultsTableViewController {
    
    private struct Storyboard {
        static let DetailSegueIdentifier = "DetailSegueIdentifier"
    }
    
    var viewContext = AppDelegate.viewContext
    
    // MARK: Model
    
    lazy var fetchedResultsController: NSFetchedResultsController<Todo> = {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Todo.created, ascending: false)]
        
        let controller = NSFetchedResultsController<Todo>(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        
        return controller
    }()
    
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
        
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.ReuseIdentifier, for: indexPath) as! TodoTableViewCell
        let todo = fetchedResultsController.object(at: indexPath)
        
        cell.delegate = self
        cell.todo = todo.task
        cell.completed = todo.completed
        cell.tags = todo.joinedTagTitles
        cell.favorized = todo.favorite
        
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    // MARK: UITableVIewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return fetchedResultsController.object(at: indexPath).completed ? .none : .delete
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
            
            dest.todo = fetchedResultsController.object(at: indexPath)
            dest.viewContext = viewContext
            
        default: break
        }
    }
    
    private func createTodo(with text: String) {
        Todo.create(with: text, in: viewContext)
        printDatabase()
    }
    
    private func printDatabase() {
        Todo.count(in: viewContext)
    }
    
    private func deleteTodo(at indexPath: IndexPath) {
        let deletedTodo = fetchedResultsController.object(at: indexPath)
        viewContext.delete(deletedTodo)
    }
}

extension TodoTableViewController: TodoTableViewCellDelegate {
    
    func todoCell(_ cell: TodoTableViewCell, wasCompleted completed: Bool) {
        let indexPath = tableView.indexPath(for: cell)!
        fetchedResultsController.object(at: indexPath).complete(to: completed)
    }
    
    func todoCell(_ cell: TodoTableViewCell, updatedTodo task: String) {
        let indexPath = tableView.indexPath(for: cell)!
        fetchedResultsController.object(at: indexPath).task = task
    }
}

extension TodoTableViewController: AddTodoViewDelegate {
    
    func addTodoView(_ view: AddTodoView, didCreateTodo task: String) {
        createTodo(with: task)
    }
}
