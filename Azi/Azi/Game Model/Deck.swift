//
//  Deck.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class Deck {
    //MARK: - Properties
    private var deck = [Card]()
    private var deckIndex = -1
    
    //MARK: - Initialiser
    init() {
       create()
    }
    
    //MARK: - Functions
    func create() {
        let suits = ["h","s","c"]
        for cardSuit in suits {
            for cardValue in 6...14 {
                let tempCard = Card(suit: cardSuit, value: cardValue)
                deck.append(tempCard)
            }
        }
    }
    
    func getTopCard() -> Card {
        deckIndex += 1
        return deck[deckIndex]
    }
    
    func new() {
        deckIndex = -1
        shuffle()
    }
    
    func shuffle() {
        deck.shuffle()
    }
    
    func leftCardsNum() -> Int {
        return deck.count - (deckIndex + 1)
    }
}
