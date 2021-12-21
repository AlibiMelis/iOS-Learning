//: Playground - noun: a place where people can play

import UIKit

class Car {
    var model: String?
}

var vehicle: Car?
vehicle = Car()
vehicle?.model = "Ferarri"
if let v = vehicle, let m = v.model {
    print(m)
}

let str = "I have to buy 3 apples, 7 bananas, 10eggs"
let strArr = str.split(separator: " ")

for item in strArr {
    let components =
        item.components(separatedBy: CharacterSet.decimalDigits.inverted)
    let part: String = components.joined()
    
    if let intVal = Int(part) {
        print("\(intVal)")
    }
}
