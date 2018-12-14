//: Playground - noun: a place where people can play

import Foundation
import UIKit

// functions as a property
var number: Int?
var toString: (Int) -> String

// treat functions as first class citizen
struct Inty {
    let int: Int
    
    init(int: Int) { self.int = int }
    
    init(buildFrom: () -> Int?) { self.int = buildFrom() ?? -1 }
}

// assign function to property
number = 5
toString = { (int: Int) -> String in // full signature
    return int.description
}
toString = { int in // infered signature
    return int.description
}
toString = { $0.description } // anonymous arguments

// call functions
number // returns 5 as an int
toString(5) // returns "5" as a string

// assign existing functions to properties
func objectOrientedToString(int: Int) -> String {
    return int.description
}

toString = objectOrientedToString // treat them as the same, because both signatures are matching

// function which takes a function (high order function)
func randomNumbertoStringPlease(f: (Int) -> String) -> String { // takes function `f`
    let randomNumber = Int(arc4random()) // e.g. 3089556946
    let stringVersion = f(randomNumber) // use function `f`. at this point we have no idea how 'f' is implemented, and we don’t have to
    return stringVersion
}

randomNumbertoStringPlease(f: { int in // implementation of 'f' is defined here
    return int.description
})

randomNumbertoStringPlease { $0.description } // trailing closure syntax
randomNumbertoStringPlease(f: toString) // passing another functions which matches signature

// functions is capturing variable
let upperBound = UInt32(100)

func capturingrandomNumbertoStringPlease(f: (Int) -> String) -> String { // `upperBound` is available here
    let randomNumber = Int(arc4random_uniform(upperBound)) // e.g. 50
    let stringVersion = f(randomNumber)
    return stringVersion
}

capturingrandomNumbertoStringPlease(f: toString)

// function which returns a function
struct Student { let name: String } // given this
struct Certificate { let date: Date; let student: Student } // and that
    
// 'certificates' takes 'Date' and returns a function which takes 'Student' and returns 'Certificate'
let certificates: (Date) -> (Student) -> Certificate = { date in
    return { student in Certificate(date: date, student: student) }
}

let now = Date() // of type `Date`
let grantCertificate = certificates(now) // of type `(Student) -> Certificate`

["A", "B", "C"] // Array<String>
    .map { s in Student(name: s) } // Array<String> -> Array<Student>
    .map { s in grantCertificate(s) } // Array<Student> -> Array<Certificate>
    .forEach { c in print(c) } // prints

// make a print function which matches the signature of `(Certificate) -> ()`
let customPrint = { (c: Certificate) in print(c) }

// inline functions which matches signature
["A", "B", "C"].map(Student.init).map(grantCertificate).forEach(customPrint)

// closures as completion handlers
let label = UILabel()

UIView.animate(withDuration: 0.1, animations: {
    label.alpha = 0.0 // label is captured here by the way
}, completion: { finished in // called when animation is finished
    label.removeFromSuperview()
})

func superHeavyCalculation(completion: () -> ()) {
    print("starting super heavy calculation")
    // calc ...
    completion()
}

superHeavyCalculation { // again, trailing closure syntax
    print("seems to be finished")
}

// lazy init blocks

let formatter = DateFormatter()
formatter.dateStyle = .short
formatter.timeStyle = .short

let formatter2: DateFormatter = {
    let f = DateFormatter()
    f.dateStyle = .short
    f.timeStyle = .short
    return f
}()

// queues

let globalQueue = DispatchQueue.global(qos: .userInitiated) // request global queue wich is user initiated (high priority)

globalQueue.async { // execute this closure asynchronously on `globalQueue` when possible
    
    // we are off the main thread now. this code block will be executed asynchronously
    
    // long running task ...
    
    // okay, i'am done here. ready to go on main thread
    
    let mainQueue = DispatchQueue.main // request (the one and only) main queue
    
    mainQueue.async { // execute this closure asynchronously on `mainQueue` when possible
        
        // we are back on main thread now. use your result here to update the UI
    }
}

print("1")

DispatchQueue.global(qos: .userInitiated).async {
    // we are off the main thread now. this code block will be executed asynchronously
    print("2")
    // okay, i'am done here. ready to go on main thread
    print("3")
    
    DispatchQueue.main.async {
        // we are back on main thread now. use your result here to update the UI
        print("4")
    }
    
    print("5")
}

print("6")

print(Thread.isMainThread) // true

DispatchQueue.global(qos: .userInitiated).async {
    print(Thread.isMainThread) // false
    
    DispatchQueue.main.async {
        print(Thread.isMainThread) // true
    }
}

print(Thread.isMainThread) // false
