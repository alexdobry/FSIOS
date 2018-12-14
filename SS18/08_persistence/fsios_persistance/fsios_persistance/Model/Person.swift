//
//  Person.swift
//  fsios_persistance
//
//  Created by Alex on 01.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import CoreData

class Person: NSManagedObject {
    
    static func create(with name: String, age: Int, gender: Gender, street: String, city: String, in context: NSManagedObjectContext) -> Person {
        let person = Person(context: context)
        person.name = name
        person.age = Int16(age)
        person.gender = gender.rawValue
        
        let address = Address(context: context)
        address.street = street
        address.city = city
        person.address = address
        
        // try? context.save() // in memory otherwise
        
        return person
    }
}

