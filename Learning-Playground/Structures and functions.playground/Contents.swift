import UIKit
struct square {
    func perimetre (lenght: Int, height: Int) -> Int {
        let p = (lenght + height) * 2
        return p
    }
    func area (lenght: Int, height: Int) -> Int {
        let a = lenght * height
        return a
    }
}

var tortburysh = square()
print ("\(tortburysh.area(lenght: 8, height: 5))")

func pA (height: Int, lenght: Int) -> (p: Int, a: Int) {
    let perimetre = (height + lenght) * 2
    let area = height * lenght
    return (perimetre, area)
}

let tort = pA(height: 5, lenght: 6)
print("\(tort.a)")
print(tort)
