//
//  TodoType.swift
//  Yatodoa
//
//  Created by Alex on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum ToDoType {
    case add, open, done
}

extension ToDoType {
    
    init(todo: ToDo) {
        if todo.isEmpty {
            self = .add
        } else {
            self = todo.completed ? .done : .open
        }
    }
    
    var headerTitle: String {
        switch self {
        case .add: return "Neu Hinzufügen"
        case .open: return "Offen"
        case .done: return "Erledigt"
        }
    }
    
    static func < (lhs: ToDoType, rhs: ToDoType) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
}
