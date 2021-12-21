//
//  PlayerNode.swift
//  Azi
//
//  Created by Alibi on 5/12/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation
import SpriteKit
import Firebase

class PlayerNode: SKSpriteNode {
    //MARK: - Properties
    var nickname: SKLabelNode!
    var playerTimer: Timer!
    var playerKey: String!
    var hand = Hand()
    
    //MARK: - Initialiser
    init() {
        let texture = SKTexture(image: UIImage(named: "emptyPlayer")!)
        
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        drawBorder(color: UIColor.black, width: 3, inSize: CGSize(width: 61, height: 61), cornerRadius: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ALIBI: init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func playerSat(_ player: Player, withImage img: UIImage? = nil) {
        self.childNode(withName: "nickname")?.removeFromParent()
        self.playerKey = player.userKey
        
        if img != nil {
            self.texture = SKTexture(image: img!)
        } else {
            if player.imageURL != "default" {
                let ref = Storage.storage().reference(forURL: player.imageURL)
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("ALIBI: Couldn't download image from Firebase Storage")
                    } else {
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.texture = SKTexture(image: img)
                                MainVC.imageCache.setObject(img, forKey: player.imageURL as NSString)
                            }
                        }
                    }
                })
            } else {
                self.texture = SKTexture(image: UIImage(named: "avatar")!)
            }
        }
        let nickname = SKLabelNode(text: player.nickname)
        nickname.fontColor = UIColor.white
        addChild(nickname)
        nickname.fontName = "Avenir Next Condensed"
        adjustLabelFontSizeToFitRect(labelNode: nickname, rect: CGRect(x: self.frame.midX, y: self.frame.midY - 12, width: self.frame.width, height: 12))
        nickname.position = CGPoint(x: 0, y: -size.height / 2 + 2)
        nickname.name = "nickname"
        
        
    }
    
    func reset(deckPosition position: CGPoint) {
        self.texture = SKTexture(image: UIImage(named: "emptyPlayer")!)
        self.childNode(withName: "nickname")?.removeFromParent()
        self.playerKey = ""
        for i in 0..<hand.getNum() {
            self.hand.cardWithIndex(i).backToDeck(position: position)
        }
    }
    func removeReady() {
        childNode(withName: "ready")?.removeFromParent()
    }
    
    func adjustLabelFontSizeToFitRect(labelNode: SKLabelNode, rect: CGRect) {
        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
        labelNode.fontSize *= scalingFactor
    }
}

extension SKSpriteNode {
    func drawBorder(color: UIColor, width: CGFloat, inSize size: CGSize, cornerRadius: CGFloat) {
        let shapeNode = SKShapeNode(rectOf: size, cornerRadius: cornerRadius)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
}

extension PlayerNode {
    func startTimerAround() {
        addCircle()
    }
    
    func stopTimer() {
        childNode(withName: "circle")?.removeFromParent()
        let readyNode = SKSpriteNode(imageNamed: "accept")
        addChild(readyNode)
        readyNode.position = CGPoint(x: 25, y: 25)
        readyNode.size = CGSize(width: 15, height: 15)
        readyNode.name = "ready"
    }
    func addCircle() {

        let path = getCirclePath(ofRadius: 30, withPercent: 1)

        let shapeNode = SKShapeNode(path: path)
        shapeNode.strokeColor = .green
        shapeNode.fillColor = .clear
        shapeNode.lineWidth = 2
        shapeNode.lineCap = .round
        shapeNode.position = CGPoint(x: 0, y: 0)
        shapeNode.zRotation =  CGFloat.pi * 0.5
        shapeNode.name = "circle"

        self.addChild(shapeNode)


        animateStrokeEnd(circle: shapeNode, duration: 30){
            shapeNode.path = nil
            print("Done")
        }
    }

    func getCirclePath(ofRadius radius: CGFloat, withPercent percent: CGFloat) -> CGPath {
        return  UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * .pi * percent, clockwise: true).cgPath
    }

    func animateStrokeEnd(circle: SKShapeNode, duration: TimeInterval, completion: @escaping () -> Void)  {
        guard let path = circle.path else {
            return
        }
        let radius = path.boundingBox.width / 2
        let animationAction = SKAction.customAction(withDuration: duration) { (node, elpasedTime) in
            let percent =  elpasedTime/CGFloat(duration)
            (node as! SKShapeNode).path = self.getCirclePath(ofRadius: radius, withPercent: 1 - percent)
        }
        circle.run(animationAction) {
            completion()
        }
    }
}
