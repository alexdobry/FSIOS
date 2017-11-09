//
//  Todo.swift
//  Done
//
//  Created by Alex on 07.11.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Todo: Equatable {
    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return lhs.task == rhs.task
    }
    
    let task: String
    let completed: Bool
}
