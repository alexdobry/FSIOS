//
//  ViewController.swift
//  Yatodoa
//
//  Created by Uwe Müsse on 24.10.17.
//  Copyright © 2017 Uwe Müsse. All rights reserved.
//

import UIKit


class TodoViewController: UIViewController, TodoViewDelegate {
    
    @IBOutlet weak var summary: UILabel! // view
    @IBOutlet var todoView: [TodoView]! // view
    
    var completedTasks: [Todo] = [] { // model
        didSet {
            let count = completedTasks.count
            summary.text = (count==1) ? "\(count) Aufgabe erledigt" : "\(count) Aufgaben erledigt"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoView.forEach { todoView in
            todoView.delegate = self
        }
    }
    
    func todoViewHasBeenToggled(task: String, completed: Bool, changed: Date?) {
        var todo:Todo
        if let changedDate = changed {
            todo = Todo(task: task, completed: completed, changed: changedDate)
        }else{
            todo = Todo(task: task, completed: completed)
        }
        
        if completed {
            completedTasks.append(todo)
        } else {
            _ = completedTasks.remove(element: todo)
        }
    }
}
