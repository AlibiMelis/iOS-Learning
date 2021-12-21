//: Playground - noun: a place where people can play

import UIKit

enum TacoProtein: String {
    case Beef = "Beef"
    case Chicken = "Chicken"
    case Brisket = "Brisket"
    case Fish = "Fish"
}

struct Taco {
    
    private var _proteinId: TacoProtein!
    
    var proteinId: TacoProtein {
        return _proteinId
    }
    
    init(proteinId: Int) {
        
        switch proteinId {
        case 2:
            self._proteinId = TacoProtein.Brisket
        default:
            self._proteinId = TacoProtein.Beef
        }
        
    }
    
}
let taco1 = Taco(proteinId: 3)

print(taco1.proteinId.rawValue)


