//
//  Extensions.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        if count < 2 {
            return
        }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}
