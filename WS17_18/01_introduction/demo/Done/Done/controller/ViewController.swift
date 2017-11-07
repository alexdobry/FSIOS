//
//  ViewController.swift
//  Done
//
//  Created by Alex on 11.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController {

    @IBOutlet weak var summary: UILabel! // view
    @IBOutlet var todoView: [TodoView]! // view
    
    var completedTasks: [Todo] = [] { // model
        didSet {
            let prefix = completedTasks.isEmpty ? "Keine" : String(completedTasks.count)
            summary.text = "\(prefix) Aufgaben erledigt"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoView.forEach { todoView in
            todoView.parentController = self
        }
    }
    
    func todoViewHasChanged(task: String, completed: Bool) {
        let todo = Todo(task: task, completed: completed)
        
        if completed {
            completedTasks.append(todo)
        } else {
            _ = completedTasks.remove(element: todo)
        }
    }
}

