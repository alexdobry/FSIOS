//
//  TodoTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 21.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum TodoType {
    case add, open, done
}

extension TodoType {
    
    init(todo: ToDo) {
        self = todo.task.isEmpty ? .add : (todo.completed) ? .done : .open
    }
    
    var title: String {
        switch self {
            case .add: return "Neu Hinzufügen"
            case .open: return "offen"
            case .done: return "Erledigt"
        }
    }
    
    static func < (lhs: TodoType, rhs: TodoType) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
}

class TodoTableViewController: UITableViewController {

    var todos: [ToDo] = [] {
        didSet {
            print(todos)
            
            todoSections = todos.groupBy(key: { todo in
                return TodoType(todo: todo)
            }).sorted(by: { (l, r) in
                return l.key < r.key
            })
        }
    }
    
    var todoSections: [(key: TodoType, value: [ToDo])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: TodoTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: TodoTableViewCell.ReuseIdentifier)
        tableView.register(UINib(nibName: AddTodoTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: AddTodoTableViewCell.ReuseIdentifier)
       
        todos.append(ToDo.empty)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return todoSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoSections[section].value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch todoSections[indexPath.section].key {
        case .add:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTodoTableViewCell.ReuseIdentifier, for: indexPath) as! AddTodoTableViewCell
            
            cell.delegate = self
            
            return cell
        case .open, .done:
            let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.ReuseIdentifier, for: indexPath) as! TodoTableViewCell
            
            let todo = todoSections[indexPath.section].value[indexPath.row]
            cell.todo = todo.task
            cell.completed = todo.completed
            cell.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todoSections[section].key.title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch todoSections[indexPath.section].key {
        case .add, .done:
            return false
        case .open:
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            todos.remove(at: indexPath.row + 1)
            
            //tableView.reloadData()
            
            if(todos.count > 1){
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else{
                let indexSet = IndexSet(integer: indexPath.section)
                tableView.deleteSections(indexSet, with: .automatic)
            }
        }
    }
    
    private func insert(_ todo: ToDo, animated: Bool) {
        if animated {
            let section = TodoType.open
            let sectionExists = todoSections.contains(where: { entry in entry.key == section })
            todos.append(todo)
            
            let nextPositon = todoSections.first(where: { entry in entry.key == section })!.value.count - 1
            
            let indexPath = IndexPath(row: nextPositon, section: section.hashValue)
            
            if sectionExists {
                tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            } else {
                tableView.beginUpdates()
                tableView.insertSections(IndexSet(integer: section.hashValue), with: .automatic)
                tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.endUpdates()
            }
            
            
        } else {
            todos.append(todo) // update model
            tableView.reloadData()
        }
    }
}

extension TodoTableViewController: AddTodoTableViewCellDelegate {
    func addTodoCell(_ cell: AddTodoTableViewCell, didCreateTodo todo: String) {
        insert(ToDo(task: todo), animated: true)
        
        cell.textField.text = nil
    }
}

extension TodoTableViewController: TodoTableViewCellDelegate {
    func todoCell(_ cell: TodoTableViewCell, wasCompleted completed: Bool) {
        let indexPath = tableView.indexPath(for: cell)!
        let todo = todoSections[indexPath.section].value[indexPath.row]
        
        if let index = todos.index(of: todo) {
            todos[index] = ToDo(task: todo.task, completed: completed)
            tableView.reloadData()
        }
        
    }
}

