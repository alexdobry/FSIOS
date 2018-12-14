//
//  Tag.swift
//  Yatodoa
//
//  Created by Alex on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Tag: NSManagedObject {
    
    var color: UIColor? {
        get {
            if let hex = colorHex {
                return UIColor.init(hex: hex)
            } else {
                return nil
            }
        }
        set {
            colorHex = newValue?.toHex
        }
    }
    
    static func populateItemsIfNeeded(in context: NSManagedObjectContext) throws {
        do {
            let request: NSFetchRequest<Tag> = Tag.fetchRequest()
            let existing = try context.count(for: request)
            
            if existing > 0 {
                print(#function, "already created")
            } else {
                ["#general", "#shopping list", "#study", "#work", "#yolo", "#swag"].forEach { title in
                    Tag.create(with: title, in: context)
                }
                
                try? context.save()
            }
        } catch {
            throw error
        }
    }
    
    static func create(with title: String, in context: NSManagedObjectContext) {
        let tag = Tag(context: context)
        tag.title = title
        tag.color = UIColor.random // TODO
    }
}

