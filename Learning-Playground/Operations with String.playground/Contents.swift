//: Playground - noun: a place where people can play

import UIKit

var welcome = "hello"
welcome.insert("!", at: welcome.index(welcome.endIndex, offsetBy:-3))
welcome.remove(at: welcome.index(before: welcome.endIndex))
print(welcome)
