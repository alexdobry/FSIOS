//
//  ViewController.swift
//  Done
//
//  Created by Alex on 11.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController {
        
    /*@IBOutlet weak var doneLabel: UILabel! {
        didSet { doneLabel.isHidden = true } // no todo is done in the beginning
    }
    
    @IBOutlet weak var todosStackView: UIStackView!
    @IBOutlet weak var doneStackView: UIStackView!
    
    fileprivate func addTodoView() {
        let view = ToDoView()
        view.delegate = self
        
        view.isHidden = true // view takes no space
        view.alpha = 0.0 // view is also transparent
        
        todosStackView.addArrangedSubview(view)
        
        UIView.animate(withDuration: ViewConstants.DefaultExpandingAnimationDuration, animations: {
            view.alpha = 1.0 // view turns from transparent to opaque
            view.isHidden = false // view slides in and constraints to layout
        }, completion: { _ in
            // debugging only
            print("bounds (local): \(view.bounds), frame (superview): \(view.frame)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toDoView = todosStackView.arrangedSubviews.first as! ToDoView // "your todo" view
        toDoView.delegate = self
        
        let fake = doneStackView.arrangedSubviews.first!
        fake.removeFromSuperview() // remove "mock" view from storyboard. doneStackView.removeArrangedSubview(fake) only makes it invisible
        
        // populate(10)
    }
    
    // populate n todo entries for debuggen purpose
    private func populate(_ n: Int) {
        (0..<n).forEach { i in
            let focusTodoView = todosStackView.arrangedSubviews.last as! ToDoView
            focusTodoView.todo = "\(i)"
            
            addTodoView()
        }
    }
    
    private func updateDoneLabel() {
        let count = doneStackView.arrangedSubviews.count
        doneLabel.text = "Erledigt: \(count) \(count == 1 ? "ToDo" : "ToDos")"
        
        UIView.animate(withDuration: ViewConstants.DefaultExpandingAnimationDuration/2, animations: {
            self.doneLabel.isHidden = count == 0 // let "doneLabel" appear or disappear
        })
    }*/
}

extension ToDoViewController: ToDoViewDelegate {
    
    func todoView(_ todoView: ToDoView, wasCompleted completed: Bool, withToDo todo: String) {
        /*let todoItem = ToDo(task: todo, completed: completed)
        
        if completed {
            // todoView is visible and opaque
            
            UIView.animate(withDuration: ViewConstants.DefaultExpandingAnimationDuration/2, animations: {
                // make todoView transparent and hide it
                todoView.alpha = 0.0
                todoView.isHidden = !todoView.isHidden
            }, completion: { _ in
                // move todoView from "todoSV" to "doneSV"
                self.todosStackView.removeArrangedSubview(todoView)
                self.doneStackView.addArrangedSubview(todoView)
                
                UIView.animate(withDuration: ViewConstants.DefaultExpandingAnimationDuration/2, animations: {
                     // let todoView appear on screen and become opaque
                    todoView.isHidden = !todoView.isHidden
                    todoView.alpha = 1.0
                }, completion: { _ in
                    // right after todoView is visible we will show the date, which will also be animated
                    todoView.date = todoItem.finished
                    
                    // after todoView was moved successfully we will update the "done label"
                    self.updateDoneLabel()
                })
            })
        } else {
            // kinda the reverse animation from above
            
            // todoView is visible and opaque
            
            // hide the date first
            todoView.date = nil
            
            // because hiding the date is also animated, we need to wait until it is finished. thus "delay" is set to "DefaultExpandingAnimationDuration"
            UIView.animate(
                withDuration: ViewConstants.DefaultExpandingAnimationDuration/2,
                delay: ViewConstants.DefaultExpandingAnimationDuration,
                options: [],
                animations: {
                    // after date disappeared we make todoView transparent and hide it
                    todoView.alpha = 0.0
                    todoView.isHidden = !todoView.isHidden
                },
                completion: { _ in
                    // move todoView from "doneSV" to "todoSV"
                    self.doneStackView.removeArrangedSubview(todoView)
                    self.todosStackView.insertArrangedSubview(todoView, at: 0)
                    
                    UIView.animate(withDuration: ViewConstants.DefaultExpandingAnimationDuration/2, animations: {
                        // after todoView is hidden and moved between stackView we make todoView appear on screen and become opaque
                        todoView.isHidden = !todoView.isHidden
                        todoView.alpha = 1.0
                    }, completion: { _ in
                        // after todoView was moved successfully we will update the "done label"
                        self.updateDoneLabel()
                    })
                }
            )
        }*/
    }
    
    func todoView(_ todoView: ToDoView, didCreateTodo string: String?) {
        /*guard let string = string, !string.isEmpty else { return }

        addTodoView()*/
    }
}
