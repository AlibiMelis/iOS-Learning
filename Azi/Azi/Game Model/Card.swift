//
//  Card.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation
import SpriteKit

class Card: SKSpriteNode {
    //MARK: - Properties
    private var suit: String = ""
    private var value: Int = 0
    
    //MARK: - Initialiser
    init(suit: String, value: Int) {
        self.suit = suit
        self.value = value
        let texture = SKTexture(imageNamed: suit + String(value))
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
    }
    
    init(card: String) {
        let texture = SKTexture(imageNamed: card)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Functions
    func getValue() -> String {
        return suit + String(value)
    }
    func backToDeck(position: CGPoint) {
        let backToDeckMove = SKAction.move(to: position, duration: 0.5)
        self.run(backToDeckMove, completion: { () in
            self.removeFromParent()
        })
    }
}
