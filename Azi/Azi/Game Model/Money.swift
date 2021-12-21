//
//  Money.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation
import SpriteKit

class Money: SKSpriteNode {
    //MARK: - Properties
    private var moneyValue = 100000
    
    //MARK: - Initialiser
    init(moneyValue: Int) {
        var texture: SKTexture
        self.moneyValue = moneyValue
        switch moneyValue {
        case 10000:
            texture = SKTexture(imageNamed: "money10000")
        case 25000:
            texture = SKTexture(imageNamed: "money25000")
        case 50000:
            texture = SKTexture(imageNamed: "money50000")
        default:
            texture = SKTexture()
        }
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "money"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: - Functions
    func getValue() -> Int {
        return moneyValue
    }
}
