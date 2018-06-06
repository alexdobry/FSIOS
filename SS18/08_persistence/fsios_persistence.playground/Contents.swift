//: Playground - noun: a place where people can play

import UIKit

// simple storage with auto fallback
let shoudSendNotifications = UserDefaults.standard.bool(forKey: "should send notifications") // false
UserDefaults.standard.set(true, forKey: "should send notifications")
let shoudNowSendNotifications = UserDefaults.standard.bool(forKey: "should send notifications") // true

// simple storage with nil
let filter = UserDefaults.standard.string(forKey: "Filter Setting") // nil
UserDefaults.standard.set("Completed Only", forKey: "Filter Setting")

if let filterNow = UserDefaults.standard.string(forKey: "Filter Setting"), filterNow == "Completed Only" {
    print("filter by completed only")
} else {
    print("other filter")
}

// advanced storage with algebra
enum Filter: Int { // conformance to Int is important here
    case all, completed, future
}

extension UserDefaults { // by extending UserDefaults we can add first class Properties to UserDefaults
    
    var filter: Filter { // simple api is hiding complexity of get and set
        get {
            let int = UserDefaults.standard.integer(forKey: #function) // #function ensures uniqueness within this scope
            return Filter(rawValue: int) ?? .all // try to build a filter from int
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: #function) // save enums by their rawValue (Integer in this case)
        }
    }
}

let filterEnum = UserDefaults.standard.filter // .all, which is the fallback
UserDefaults.standard.filter = .completed

switch UserDefaults.standard.filter {
    case .all: print("show everything")
    case .completed: print("filter by completed only") // this should be it
    case .future: print("filter by future only")
}

struct Person: Codable { // implement Codable
    let name: String
    let age: Int
    let address: Address
    let gender: Gender
}

struct Address: Codable { // same here
    let street: String
    let city: String
}

enum Gender: Int, Codable { // same here, backed by int as a rawValue representation
    case male, female
}

let myAddress = Address(street: "Steinmüllerallee 1", city: "Gummersbach")
let me = Person(name: "Alex", age: 28, address: myAddress, gender: .male) // hi, its me!

let meAsData = try? PropertyListEncoder().encode(me) // 163 bytes of me
// serialize me as data ...
let meFromData = try? PropertyListDecoder().decode(Person.self, from: meAsData!) // hi there!

let url = try? FileManager.default.url(
    for: .documentDirectory, // which URL
    in: .userDomainMask, // always in iOS
    appropriateFor: nil, // ignore ...
    create: true // create if needed
) // /documents

if let urlToMe = url? // /documents/persons/me.data now
    .appendingPathComponent("persons")
    .appendingPathComponent("me")
    .appendingPathExtension("data") {
        try? meAsData?.write(to: urlToMe) // try to write on disk
    
        if let meAsDataFromDisk = try? Data(contentsOf: urlToMe) { // try to read from disk
            let meFromDisk = try? PropertyListDecoder().decode(Person.self, from: meAsDataFromDisk) // deserialize
            print(meFromDisk ?? "nope") // yey or nope
        }
}
