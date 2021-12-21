//: Playground - noun: a place where people can play

import UIKit

var airports: [String: String] = ["ALM": "Alamty International Airmort", "RSH": "Sheremetievo Airport"]
airports["JFK"] = "John F. Khenedy Airport" //Adding an element to dictionary
for (key, value) in airports {
    print("Key: \(key) stands for airport: \(value)")   //Any word can be used instead of "key" and "value"
}

for key in airports.keys {
    print("Key: \(key)")
}

for value in airports.values {
    print("Value: \(value)")
}
