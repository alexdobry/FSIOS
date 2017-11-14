//
//  Todo.swift
//  Yatodoa
//
//  Created by Alex on 07.11.17.
//  Copyright © 2017 Uwe Müsse. All rights reserved.
//

import Foundation

struct Todo: Equatable {
    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return lhs.task == rhs.task
    }
    
    init(task:String, completed: Bool, changed: Date){
        self.task = task
        self.completed = completed
        self.changed = changed
    }
    
    init(task:String, completed: Bool){
        self.task = task
        self.completed = completed
        self.changed = nil
    }
    
    let task: String
    let completed: Bool
    let changed: Date?
}
