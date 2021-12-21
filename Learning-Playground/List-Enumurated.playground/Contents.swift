//: Playground - noun: a place where people can play

import UIKit

var shoppingList = ["Six eggs", "Milk", "Flour", "Baking Powder", "Bananas"]
for (index,value) in shoppingList.enumerated() {
    print("Item \(index + 1): \(value)")
}
for (_,value) in shoppingList.enumerated() {
    print(value)
}
print(shoppingList.endIndex)


