//: ## Devslopes POP
//: ### Protocol Oriented Programming
//: Protocols

import UIKit

protocol Vehicle: CustomStringConvertible {
    var isRunning: Bool { get set }
    var description: String { get }
    mutating func start()
    mutating func turnOff()
}

struct SportsCar: Vehicle {
    var isRunning: Bool = false
    
    var description: String {
        if isRunning {
            return "Sports car currently running"
        } else {
            return "Sports car currently turned off"
        }
    }
    
    mutating func start() {
        if isRunning {
            print("Already started!")
        } else {
            isRunning = true
            print("Vrooom")
        }
    }
    
    mutating func turnOff() {
        if isRunning {
            isRunning = false
            print("Crickets")
        } else {
            print("Already dead")
        }
        
    }
}

class SemiTruck: Vehicle {
    var isRunning: Bool = false
    var description: String {
        if isRunning {
            return "Semi truck currently running"
        } else {
            return "Semi truck currently shut down"
        }
    }
    
    func start() {
        if isRunning {
            print("Already started!")
        } else {
            isRunning = true
            print("Rumble")
        }
    }
    
    func turnOff() {
        if isRunning {
            isRunning = false
            print("put..put...silence")
        } else {
            print("Already shut down!")
        }
    }
    
    func blowAirHorn() {
        print("TOOOOOOT :)")
    }
}


var car1 = SportsCar()
var truck1 = SemiTruck()

car1.start()
truck1.start()
truck1.blowAirHorn()

car1.turnOff()
truck1.turnOff()

var vehicleArray: Array<Vehicle> = [car1, truck1]
for vehicle in vehicleArray {
    print("\(vehicle.description)")
//    if let vehicle = vehicle as? SemiTruck {
//        print("\(vehicle.description)")
//    }
}

