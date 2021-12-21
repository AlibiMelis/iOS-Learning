//: Playground - noun: a place where people can play

import UIKit

class vehicle {
    var model = "bmw"
    var horsePower: Double = 100
    var cvet = "Black"
    var wheels: Double = 4
    func horsePowerPerWheel() -> Double {
        return horsePower/wheels
    }
}

let myCar = vehicle()

print(myCar.model)
myCar.cvet = "yellow"
myCar.model = "Porsche"
myCar.wheels = 5

print(myCar.cvet)
print(myCar.model)
print(myCar.horsePowerPerWheel())

