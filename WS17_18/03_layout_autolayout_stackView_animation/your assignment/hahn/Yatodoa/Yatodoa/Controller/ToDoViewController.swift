//
//  ViewController.swift
//  Done
//
//  Created by Alex on 11.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController {
    
    // MARK: View
    @IBOutlet weak var todoStackView: UIStackView!
    @IBOutlet weak var doneTodoStackView: UIStackView!
    @IBOutlet weak var doneContainerTodoStackView: UIStackView!
    
    var openToDos: [ToDo] = []
    // MARK: Model
    var completedToDos: [ToDo] = [] {
        didSet {
            let count = completedToDos.count
            let prefix = completedToDos.isEmpty ? "Keine" : String(count)
            let task = count == 1 ? "Aufgabe" : "Aufgaben"
            
            //summary.text = "\(prefix) \(task) erledigt"
        }
    }
    
    // MARK: Viewcontroller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: Assignment
        let first = todoStackView.arrangedSubviews.first as! ToDoView
        first.delegate = self
        
        doneContainerTodoStackView.isHidden = true
        
        populate(10)
    }
    
    private func populate(_ n: Int) {
        (0..<n).forEach { i in
            let current = todoStackView.arrangedSubviews.last as! ToDoView
            current.textField.text = "\(i)"
            
            addTodoView()
        }
    }
    
    private func addTodoView() {
        let view = ToDoView()
        view.delegate = self
        
        view.alpha = 0.0 // view is transparent
        view.isHidden = true // view is invisible
        
        todoStackView.addArrangedSubview(view)
        
        // make view visible over 1.0 seconds
        UIView.animate(withDuration: 1.0, animations: {
            // make view visible again and fully opaque
            view.isHidden = false
            view.alpha = 1.0
        })
    }
}

// MARK: ToDoViewDelegate
extension ToDoViewController: ToDoViewDelegate {
    
    func todoView(_ todoView: ToDoView, didCreateTodo todo: String) {
        addTodoView()
    }
    
    func todoView(_ todoView: ToDoView, wasCompleted completed: Bool, withToDo todo: String) {
        let todoItem = ToDo(task: todo, completed: completed)
        
        if completed {
            todoView.date = todoItem.finished
            doneTodoStackView.addArrangedSubview(todoView)
            completedToDos.append(todoItem)
            _ = openToDos.remove(element: todoItem)
        } else {
            todoView.date = nil
            todoStackView.addArrangedSubview(todoView)
            openToDos.append(todoItem)
            _ = completedToDos.remove(element: todoItem)
        }
        
        if (completedToDos.count != 0) {
            doneContainerTodoStackView.isHidden = false
        } else {
            doneContainerTodoStackView.isHidden = true
        }
    }
}
