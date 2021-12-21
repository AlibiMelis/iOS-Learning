//: Playground - noun: a place where people can play

import UIKit

var array: [Int] = [1, 7, 8, 4, 0, 3]
array.insert(18, at: 2)

var index = 0
var sum = 0
repeat {
    sum += array[index]
    index += 1
} while (index < array.count)
print(sum)

for number in array {
    print(number)
}
var sum1 = 0
for i in 2...4 {
    sum1 += array[i]
    print(sum1)
}

func combiningArrays(array1: [Any], array2: [Any]) -> [Any] {
    var combinedArray = [Any]()
    let maxIndex = array1.count >= array2.count ? array1.count - 1 : array2.count - 1
    for i in 0...maxIndex {
        if (array1.count > i) {
            combinedArray.append(array1[i])
        }
        if (array2.count > i) {
            combinedArray.append(array2[i])
        }
    }
    return combinedArray
}

print(combiningArrays(array1: ["a", "b", "c"], array2: ["bo", "ro", "me"]))
