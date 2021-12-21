//
//  Hand.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class Hand {
    //MARK: - Properties
    private var hand = [Card]()

    //MARK: - Functions
    func addCard(card: Card) {
        hand.append(card)
    }
    
    func cardWithIndex(_ i: Int) -> Card {
        return hand[i]
    }
    
    func reset() {
        hand.removeAll()
    }
    
    func getNum() -> Int {
        return hand.count
    }
}
