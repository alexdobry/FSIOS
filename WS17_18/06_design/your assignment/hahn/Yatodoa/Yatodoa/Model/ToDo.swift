//
//  ToDo.swift
//  Done
//
//  Created by Alex on 13.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct ToDo: CustomStringConvertible {
    var task: String
    var favorite: Bool
    var notes: String?
    var tag: String?
    var completed: Bool {
        didSet { finished = completed ? Date() :  nil }
    }
    
    private(set) var finished: Date?
    private(set) var id: UUID
    
    var isEmpty: Bool {
        return task.isEmpty
    }
    
    private init(task: String, completed: Bool) {
        self.id = UUID()
        self.task = task
        self.completed = completed
        self.favorite = false
        self.finished = completed ? Date() :  nil
    }
    
    init (task: String) {
        self.init(task: task, completed: false)
    }
    
    static let empty = ToDo(task: "")
    
    var description: String {
        return isEmpty ? "empty" : "task: \(task), completed: \(completed), favorite: \(favorite)"
    }
}

extension ToDo: Equatable {
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
}
