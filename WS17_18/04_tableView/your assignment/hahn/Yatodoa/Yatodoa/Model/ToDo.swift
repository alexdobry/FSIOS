//
//  ToDo.swift
//  Done
//
//  Created by Alex on 13.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct ToDo {
    let task: String
    let completed: Bool
    
    private(set) var finished: Date?
    
    init(task: String, completed: Bool) {
        self.task = task
        self.completed = completed
        self.finished = completed ? Date() : nil
    }
    
    init(task: String) {
        self.init(task: task, completed: false)
    }
    
    static let empty = ToDo(task: "")
}

extension ToDo: Equatable {
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.task == rhs.task
    }
}
