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
    
    // FIXME: Assignment
    private(set) var finished: Date?
    
    // FIXME: Assignment
    public init(task: String, completed: Bool) {
        self.task = task
        self.completed = completed
        self.finished = completed ? Date() : nil
    }
}

extension ToDo: Equatable {
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.task == rhs.task
    }
}
