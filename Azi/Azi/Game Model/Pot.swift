//
//  Pot.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class Pot {
    //MARK: - Properties
    private var pot = 0

    //MARK: - Functions
    func addMoney(amount: Int) {
        pot += amount
    }
    
    func getMoney() -> Int {
        return pot
    }
    
    func reset() {
        pot = 0
    }

    
}
