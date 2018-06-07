//
//  Todo.swift
//  Done
//
//  Created by Alex on 13.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation
import CoreData

class Todo: NSManagedObject {
    
    var joinedTags: [Tag] {
        return tags?.flatMap { $0 as? Tag } ?? []
    }
    
    var joinedTagTitles: [String] {
        return joinedTags.flatMap { $0.title }
    }
    
    func complete(to bool: Bool) {
        completed = bool
        finished = bool ? Date() : nil
    }
    
    static func create(with task: String, in context: NSManagedObjectContext) {
        let todo = Todo(context: context)
        todo.id = UUID()
        todo.created = Date()
        todo.task = task
        todo.completed = false
        todo.favorite = false
        todo.finished = nil
        
        try? context.save()
    }
    
    static func count(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            print(#function, count)
        } catch {
            print(#function, error.localizedDescription)
        }
    }
}
