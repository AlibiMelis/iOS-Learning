//
//  Bank.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class Bank {
    //MARK: - Properties
    var balance = 500
  
    //MARK: - Initialiser
    init() {
        
    }
  
    //MARK: - Functions
    func resetBalance(){
        balance = 500
    }
  
    func addMoney(amount: Int) {
        balance += amount
    }
  
    func subtractMoney(amount: Int) {
        balance -= amount
    }
  
    func getBalance() -> Int {
        return balance
    }
}
