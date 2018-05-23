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
    var tags: [String]
    var completed: Bool {
        didSet { finished = completed ? Date() :  nil }
    }
    
    private(set) var finished: Date?
    private(set) var id: UUID
    
    private init(task: String, completed: Bool) {
        self.id = UUID()
        self.task = task
        self.completed = completed
        self.favorite = false
        self.finished = completed ? Date() :  nil
        self.tags = []
    }
    
    init (task: String) {
        self.init(task: task, completed: false)
    }
    
    var description: String {
        return "id: \(id), task: \(task), completed: \(completed), tags: \(tags)"
    }
}

extension ToDo: Equatable {
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
}
