//
//  GameScene.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import SpriteKit
import GameplayKit
import Firebase

class GameScene: SKScene {
    //MARK: - Variables
    weak var vc: GameViewController!
    
    var game: Game!
    var otherPlayers: [Player]!
    
    var width: Double = 0
    var height: Double = 0
    
    var amReady = false
    var stack = Double()
    
    var allCards = [Card]()
    
    var addingFriends = false
    var isBetting = false
    var round = 1
    
    var betTimer = Timer()
    
    //MARK: - Objects
    var otherPlayersSprites = [PlayerNode]()
    
    let selfSprite = PlayerNode()
    let leaveButton = SKSpriteNode(imageNamed: "leave")
    let deck = Deck()
    let deckOnTable = Card(suit: "card_front", value: 0)
    let readyButton = SKSpriteNode(imageNamed: "accept")
    let friendsButton = SKSpriteNode(imageNamed: "add")
    var stackLabel = SKLabelNode(text: "0.0")
    
    let checkButton = SKSpriteNode(imageNamed: "accept")
    let betButton = SKSpriteNode(imageNamed: "add")
    
    var myHand = Hand()
    var myHiddenHand = Hand()
    
    //MARK: - Scene loaded
    override func didMove(to view: SKView) {
        setupTable()
        setupPlayerSlots()
        createSelfView()
        downloadPlayersData()
        
        startTimerForGame()
    }
    
    //MARK: - Functions
    func setupTable() {
        width = Double(size.width)
        height = Double(size.height)
        
        let table = SKSpriteNode(imageNamed: "table")
        table.position = CGPoint(x: width/2, y: height/2)
        table.size.height = self.size.height
        addChild(table)
        table.zPosition = -1
        let userTable = SKSpriteNode(color: UIColor.white, size: CGSize(width: width, height: 110))
        userTable.position = CGPoint(x: CGFloat(width / 2), y: userTable.size.height / 2)
        userTable.drawBorder(color: UIColor.white, width: 12, inSize: CGSize(width: userTable.size.width - 10, height: userTable.size.height + 10), cornerRadius: 10)
        addChild(userTable)
        userTable.zPosition = 50
        
        leaveButton.name = "leave"
        addChild(leaveButton)
        leaveButton.position = CGPoint(x: 40, y: height - 50)
        leaveButton.size =  CGSize(width: 30, height: 30)
        
        addChild(deckOnTable)
        deckOnTable.position = CGPoint(x: -5, y: height / 2 + 165)
        deckOnTable.zRotation = CGFloat(-Double.pi / 18)
        deckOnTable.zPosition = 15
        
        readyButton.name = "ready"
        addChild(readyButton)
        readyButton.position = CGPoint(x: width / 2 - 140, y: 72)
        readyButton.size = CGSize(width: 60, height: 60)
        readyButton.isHidden = true
        readyButton.zPosition = 51
        
        addChild(friendsButton)
        friendsButton.name = "friendsButton"
        friendsButton.position = CGPoint(x: width - 40, y: height - 50)
        friendsButton.size =  CGSize(width: 30, height: 30)
        
        addChild(stackLabel)
        stackLabel.position = CGPoint(x: width / 2 - 140, y: 72)
        stackLabel.fontSize = 14
        stackLabel.fontName = "Avenir Next"
        stackLabel.zPosition = 51
        stackLabel.fontColor = UIColor.black
        
        addChild(checkButton)
        addChild(betButton)
        checkButton.name = "checkButton"
        checkButton.position = CGPoint(x: width / 2 + 110, y: 72)
        checkButton.size = CGSize(width: 45, height: 45)
        checkButton.isHidden = true
        checkButton.zPosition = 51
        betButton.name = "betButton"
        betButton.position = CGPoint(x: width / 2 + 170, y: 72)
        betButton.size = CGSize(width: 45, height: 45)
        betButton.isHidden = true
        betButton.zPosition = 51
        
        deck.new()
//        addChild(moneyContainer)
//        moneyContainer.anchorPoint = CGPoint(x:0, y:0)
//        moneyContainer.position = CGPoint(x:size.width/2 - 125, y:size.height/2)
    }
    
    func createSelfView() {
        addChild(selfSprite)
        selfSprite.size = CGSize(width: 60, height: 60)
        selfSprite.position = CGPoint(x: width / 2, y: 72)
        selfSprite.zPosition = 100
        DataService.ds.REF_CURRENT_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            if let selfPlayerData = snapshot.value as? [String: AnyObject] {
                let nickname = selfPlayerData["nickname"]!
                let imageURL = selfPlayerData["imageURL"]!
                let me = Player(playerID: snapshot.key, playerData: ["nickname": nickname,
                                                                     "imageURL": imageURL])
                self.selfSprite.playerSat(me)
            }
        })
    }
    
    func setupPlayerSlots() {
        
        let width = Double(size.width)
        let n = Double(game.maxPlayers) - 1
        let d = (width - 60 * Double(n)) / (Double(n) + 1)
        
        for i in 0...Int(n-1) {
            let playerSlot = PlayerNode()
            addChild(playerSlot)
            let x =  Double(i) * (60 + d) + d + 30
            let y = sqrt(pow(height / 2 - 100, 2) - pow(Double(width) / 2 - x, 2)) + height / 2
            playerSlot.size = CGSize(width: 60, height: 60)
            playerSlot.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
            playerSlot.zPosition = 100
            otherPlayersSprites.append(playerSlot)
        }
        print("ALIBI: Slots created")
    }
    
    func startTimerForGame() {
        var myTimer: Timer? = nil
        DataService.ds.REF_GAMES.child(game.tableID).child("players").observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                var playersReady = 0
                for snap in snapshot {
                    if let playerData = snap.value as? [String: AnyObject] {
                        let playerKey = snap.key
                        let isReady = playerData["isReady"] as! Bool
                        if isReady {
                            playersReady += 1
                            for playerSprite in self.otherPlayersSprites where playerSprite.playerKey == playerKey {
                                playerSprite.stopTimer()
                            }
                        }
                    }
                }
                if playersReady == self.game.maxPlayers {
                    print("ALIBI: All players are ready")
                    myTimer?.invalidate()
                    myTimer = nil
                    DataService.ds.REF_GAMES.child(self.game.tableID).updateChildValues(["onGame": true])
                    self.startGame()
                }
            }
            let playersNum = snapshot.children.allObjects.count
            if playersNum == self.game.maxPlayers {
                DataService.ds.REF_GAMES.child(self.game.tableID).child("onGame").observe(.value, with: { (onGameSnapshot) in
                    
                    if let onGame = onGameSnapshot.value as? Bool {
                        if onGame {
                            print("ALIBI: Don't start timer because the game is on")
                        } else {
                            print("ALIBI: There are \(playersNum) players in game")
                            print("ALIBI: Condition check")
                            if myTimer == nil {
                                var countdown = 0
                                self.readyButton.isHidden = false
                                self.selfSprite.startTimerAround()
                                for player in self.otherPlayersSprites {
                                    player.startTimerAround()
                                }
                                myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                                    print("ALIBI: Timer = \(countdown)")
                                    countdown += 1
                                    
                                    if countdown == 20 {
                                        print("ALIBI: Timer stoped")
                                        myTimer!.invalidate()
                                        myTimer = nil
                                        if !self.amReady {
                                            self.leaveGame()
                                            self.removeFromParent()
                                            self.view?.presentScene(nil)
                                            self.vc.dismiss(animated: true, completion: nil)
                                        } else {
                                            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                                                DataService.ds.REF_GAMES.child(self.game.tableID).child("players").observeSingleEvent(of: .value, with: { (snapshot) in
                                                    let players = snapshot.children.allObjects.count
                                                    if players == self.game.maxPlayers {
                                                        DataService.ds.REF_GAMES.child(self.game.tableID).updateChildValues(["onGame": true])
                                                        self.startGame()
                                                    } else {
                                                        DataService.ds.REF_GAMES.child(self.game.tableID).child("players").child(currentUserUID).updateChildValues(["isReady": false])
                                                        
                                                    }
                                                })
                                            })
                                                
                                        }
                                    }
                                }
                            } else {
                                print("ALIBI: Timer is already running")
                            }
                        }
                    } else {
                        
                    }
                })
            } else {
                print("ALIBI: Someone left")
                for player in self.game.players {
                    DataService.ds.REF_GAMES.child(self.game.tableID).child("players").child(player.userKey).updateChildValues(["isReady": false])
                }
                self.readyButton.isHidden = true
                if myTimer != nil {
                    myTimer!.invalidate()
                    myTimer = nil
                }
            }
        })
    }
    
    func startGame() {
        selfSprite.removeReady()
        for player in otherPlayersSprites {
            player.removeReady()
        }
        giveCards()
        let onGameLabel = SKLabelNode(text: "The game is on")
        addChild(onGameLabel)
        onGameLabel.position = CGPoint(x: self.width / 2, y: self.height / 2)
        onGameLabel.fontName = "Avenir Next"
        onGameLabel.fontColor = UIColor.green
    }
    
    func giveCards() {
        DataService.ds.REF_GAMES.child(game.tableID).observe(.value, with: { (snapshot) in
            if let gameData = snapshot.value as? [String: AnyObject] {
                let gameStage = gameData["gameStage"] as? String
                let bettingPlayer = gameData["betting"] as? String
                let betData = gameData["betData"] as? [String: AnyObject]
                let round1bet = betData?["1"] as? [String: Double]
                if let dealer = gameData["dealer"] as? String {
                    if dealer == currentUserUID, gameStage == nil {
                        self.deck.shuffle()
                        var cardsData: Dictionary<String, Dictionary<String, String>> = [:]
                        print("ALIBI: \(self.game.players.count)")
                        for player in self.game.players {
                            print("ALIBI: This happened")
                            var playerCards = [String: String]()
                            for card in 0...2 {
                                playerCards[String(card)] = self.deck.getTopCard().getValue()
                            }
                            cardsData[player.userKey] = playerCards
                        }
                        
                        DataService.ds.REF_GAMES.child(self.game.tableID).updateChildValues(["cardsData": cardsData,
                                                                                             "gameStage": "dealing",
                                                                                             "betting": currentUserUID])
                    } else if gameStage == "dealing" {
                        self.deliverCards()
                        print("ALIBI: Starting delivering")
                    } else if gameStage == "betting" {
                        
                        if bettingPlayer == currentUserUID {
                            if round1bet == nil {
                                self.betting()
                            } else {
                                DataService.ds.REF_GAMES.child(self.game.tableID).updateChildValues(["gameStage": "playing"])
                            }
                        }
                    } else if gameStage == "playing" {
                        
                    }
                } else {
                    if currentSeat == 1 {
                        DataService.ds.REF_GAMES.child(self.game.tableID).updateChildValues(["dealer": currentUserUID])
                    }
                }
            }
        })
    }
    
    func showCards() {
        for i in 0..<myHiddenHand.getNum() {
            myHiddenHand.cardWithIndex(i).removeFromParent()
        }
    }
    
    func betting() {
        selfSprite.startTimerAround()
        betButton.isHidden = false
        checkButton.isHidden = false
        betTimer = Timer.scheduledTimer(withTimeInterval: 31, repeats: false, block: { (timer) in
            self.passed(player: currentUserUID)
        })
    }
    
    func passed(player: String) {
        for playerSprite in otherPlayersSprites where playerSprite.playerKey == player {
            playerSprite.reset(deckPosition: deckOnTable.position)
        }
        if player == currentUserUID {
            selfSprite.reset(deckPosition: deckOnTable.position)
        }
        DataService.ds.REF_GAMES.child(game.tableID).child("players").child(player).updateChildValues(["passed": true])
    }
    
    func initialBetting() {
        print("ALIBI: Initial betting")
        vc.bet(round: 0, amount: Double(game.stake))
    }
    
    func deliverCards() {
        
        DataService.ds.REF_GAMES.child(game.tableID).child("cardsData").child(currentUserUID).observeSingleEvent(of: .value, with: { (snapshot) in
            print("ALIBI: Could you download or what?")
            if let cards = snapshot.children.allObjects as? [DataSnapshot] {
                print("ALIBI: Could download cards")
                for card in cards {
                    Timer.scheduledTimer(withTimeInterval: TimeInterval(Int(card.key)!), repeats: false, block: { (timer) in
                        let cardKey = Int(card.key)!
                        for i in 0..<self.game.players.count - 1 {
                            let tempCard = Card(suit: "card_front", value: 0)
                            self.addChild(tempCard)
                            tempCard.zPosition = CGFloat(cardKey)
                            tempCard.setScale(0.3)
                            tempCard.position = CGPoint(x: -5, y: self.height / 2 + 165)
                            tempCard.zRotation = CGFloat(-Double.pi / 18)
                            let moveCard = SKAction.move(to: CGPoint(x: self.otherPlayersSprites[i].position.x, y: self.otherPlayersSprites[i].position.y - 36), duration: 0.8)
                            Timer.scheduledTimer(withTimeInterval: TimeInterval(i) / 2, repeats: false, block: { (timer) in
                                tempCard.run(moveCard, completion: { () in
                                    self.otherPlayersSprites[i].hand.addCard(card: tempCard)
                                    let cardsNum = self.otherPlayersSprites[i].hand.getNum()
                                    if cardsNum == 1 {
                                        tempCard.zRotation = 0
                                    } else {
                                        if cardsNum % 2 == 0 {
                                            for j in 0..<cardsNum / 2 {
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).position.x -= 8
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).zRotation -= CGFloat.pi / 24
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).position.y += 3
                                            }
                                            for j in (cardsNum / 2)..<cardsNum {
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).position.x = 2 * self.otherPlayersSprites[i].position.x - self.otherPlayersSprites[i].hand.cardWithIndex(cardsNum - 1 - j).position.x
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).zRotation = -self.otherPlayersSprites[i].hand.cardWithIndex(cardsNum - 1 - j).zRotation
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).position.y = self.otherPlayersSprites[i].hand.cardWithIndex(cardsNum - 1 - j).position.y
                                            }
                                        } else {
                                            let mid = cardsNum / 2
                                            for j in 0..<mid {
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).position.x -= 8
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).zRotation -= CGFloat.pi / 24
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).position.y += 3
                                            }
                                            self.otherPlayersSprites[i].hand.cardWithIndex(mid).position.x = self.otherPlayersSprites[i].position.x
                                            self.otherPlayersSprites[i].hand.cardWithIndex(mid).zRotation = 0
                                            self.otherPlayersSprites[i].hand.cardWithIndex(mid).position.y = self.otherPlayersSprites[i].position.y - 36
                                            for j in (mid + 1)..<cardsNum {
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).position.x = 2 * self.otherPlayersSprites[i].position.x - self.otherPlayersSprites[i].hand.cardWithIndex(cardsNum - 1 - j).position.x
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).zRotation = -self.otherPlayersSprites[i].hand.cardWithIndex(cardsNum - 1 - j).zRotation
                                                self.otherPlayersSprites[i].hand.cardWithIndex(j).position.y = self.otherPlayersSprites[i].hand.cardWithIndex(cardsNum - 1 - j).position.y
                                            }
                                        }
                                    }
                                })
                            })
                        }
                        let myCard = Card(suit: "card_front", value: 0)
                        self.addChild(myCard)
                        myCard.zPosition = CGFloat(cardKey + 3)
                        myCard.setScale(0.5)
                        myCard.position = CGPoint(x: -5, y: self.height / 2 + 165)
                        let moveMyCard = SKAction.move(to: CGPoint(x: self.selfSprite.position.x, y: self.selfSprite.position.y + 50), duration: 0.8)
                        Timer.scheduledTimer(withTimeInterval: TimeInterval(Double(self.game.players.count)
                            - 1.5) / 2, repeats: false, block: { (timer) in
                            myCard.run(moveMyCard, completion: { () in
                                let myShownCard = Card(card: card.value as! String)
                                myShownCard.position = myCard.position
                                myShownCard.zPosition = myCard.zPosition - 1
                                myCard.setScale(1.6)
                                myShownCard.setScale(1.6)
                                self.addChild(myShownCard)
                                self.myHand.addCard(card: myShownCard)
                                self.myHiddenHand.addCard(card: myCard)
                                
                                let cardsNum = self.myHand.getNum()
                                if cardsNum == 1 {
                                    myShownCard.zRotation = 0
                                } else {
                                    if cardsNum % 2 == 0 {
                                        for j in 0..<cardsNum / 2 {
                                            self.myHand.cardWithIndex(j).position.x -= 17
                                            self.myHand.cardWithIndex(j).zRotation += CGFloat.pi / 32
                                            self.myHand.cardWithIndex(j).position.y -= 3
                                            self.myHiddenHand.cardWithIndex(j).position.x -= 17
                                            self.myHiddenHand.cardWithIndex(j).zRotation += CGFloat.pi / 32
                                            self.myHiddenHand.cardWithIndex(j).position.y -= 3
                                        }
                                        for j in (cardsNum / 2)..<cardsNum {
                                            self.myHand.cardWithIndex(j).position.x = 2 * self.selfSprite.position.x - self.myHand.cardWithIndex(cardsNum - 1 - j).position.x
                                            self.myHand.cardWithIndex(j).zRotation = -self.myHand.cardWithIndex(cardsNum - 1 - j).zRotation
                                            self.myHand.cardWithIndex(j).position.y = self.myHand.cardWithIndex(cardsNum - 1 - j).position.y
                                            self.myHiddenHand.cardWithIndex(j).position.x = 2 * self.selfSprite.position.x - self.myHiddenHand.cardWithIndex(cardsNum - 1 - j).position.x
                                            self.myHiddenHand.cardWithIndex(j).zRotation = -self.myHiddenHand.cardWithIndex(cardsNum - 1 - j).zRotation
                                            self.myHiddenHand.cardWithIndex(j).position.y = self.myHiddenHand.cardWithIndex(cardsNum - 1 - j).position.y
                                        }
                                    } else {
                                        let mid = cardsNum / 2
                                        for j in 0..<mid {
                                            self.myHand.cardWithIndex(j).position.x -= 17
                                            self.myHand.cardWithIndex(j).zRotation += CGFloat.pi / 32
                                            self.myHand.cardWithIndex(j).position.y -= 3
                                            self.myHiddenHand.cardWithIndex(j).position.x -= 17
                                            self.myHiddenHand.cardWithIndex(j).zRotation += CGFloat.pi / 32
                                            self.myHiddenHand.cardWithIndex(j).position.y -= 3
                                        }
                                        self.myHand.cardWithIndex(mid).position.x = self.selfSprite.position.x
                                        self.myHand.cardWithIndex(mid).zRotation = 0
                                        self.myHand.cardWithIndex(mid).position.y = self.selfSprite.position.y + 50
                                        self.myHiddenHand.cardWithIndex(mid).position.x = self.selfSprite.position.x
                                        self.myHiddenHand.cardWithIndex(mid).zRotation = 0
                                        self.myHiddenHand.cardWithIndex(mid).position.y = self.selfSprite.position.y + 50
                                        for j in (mid + 1)..<cardsNum {
                                            self.myHand.cardWithIndex(j).position.x = 2 * self.selfSprite.position.x - self.myHand.cardWithIndex(cardsNum - 1 - j).position.x
                                            self.myHand.cardWithIndex(j).zRotation = -self.myHand.cardWithIndex(cardsNum - 1 - j).zRotation
                                            self.myHand.cardWithIndex(j).position.y = self.myHand.cardWithIndex(cardsNum - 1 - j).position.y
                                            self.myHiddenHand.cardWithIndex(j).position.x = 2 * self.selfSprite.position.x - self.myHiddenHand.cardWithIndex(cardsNum - 1 - j).position.x
                                            self.myHiddenHand.cardWithIndex(j).zRotation = -self.myHiddenHand.cardWithIndex(cardsNum - 1 - j).zRotation
                                            self.myHiddenHand.cardWithIndex(j).position.y = self.myHiddenHand.cardWithIndex(cardsNum - 1 - j).position.y
                                        }
                                    }
                                }
                            })
                        })
                    })
                }
            }
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                DataService.ds.REF_GAMES.child(self.game.tableID).updateChildValues(["gameStage": "betting"])
                self.initialBetting()
            })
        })
        
    }
    
    func leaveGame() {
        
        DataService.ds.REF_GAMES.child(game.tableID).child("players").observeSingleEvent(of: .value, with: { (snapshot) in
            var playerAtSeat = [String: Int]()
            if let players = snapshot.children.allObjects as? [DataSnapshot] {
                for player in players {
                    let playerKey = player.key
                    if let playerData = player.value as? [String: AnyObject] {
                        let playerSeat = playerData["seat"] as! Int
                        playerAtSeat[playerKey] = playerSeat
                    }
                }
            }
            if snapshot.childrenCount == 1 {
                DataService.ds.REF_GAMES.child(self.game.tableID).removeValue()
            } else {
                print("ALIBI: not last leaving, that's why reseat please")
                DataService.ds.REF_GAMES.child(self.game.tableID).child("players").child(currentUserUID).removeValue()
                for (key, value) in playerAtSeat {
                    if value > currentSeat {
                        let newSeat = value - 1
                        DataService.ds.REF_GAMES.child(self.game.tableID).child("players").child(key).updateChildValues(["seat": newSeat])
                    }
                }
                
            }
        })
        DataService.ds.REF_CURRENT_USER.child("inGame").removeValue()
    }
    
    //MARK: - Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name == "leave" {
            leaveGame()
            print("ALIBI: Touching Leave Button")
            self.removeFromParent()
            self.view?.presentScene(nil)
            self.vc.dismiss(animated: true, completion: nil)
        }
        if touchedNode.name == "ready" {
            amReady = true
            readyButton.isHidden = true
            DataService.ds.REF_GAMES.child(game.tableID).child("players").child(currentUserUID).updateChildValues(["isReady": true])
            selfSprite.stopTimer()
        }
        if touchedNode.name == "friendsButton" {
            if !addingFriends {
                vc.addFriends()
                print("ALIBI: trying to add friends")
                addingFriends = true
            } else {
                vc.tableView.isHidden = true
                addingFriends = false
            }
        }
        if touchedNode.name == "betButton" {
            if !isBetting {
                vc.showBetView(minBet: Double(self.game.stake), maxBet: stack)
                isBetting = true
            } else {
                vc.bet(round: round, amount: nil)
                var i = 1
                var foundNextBetting = false
                var maybeNext: Int
                var nextBettingPlayer: String = "none"
                while !foundNextBetting {
                    if currentSeat + i > self.game.maxPlayers {
                        i = 1 - currentSeat
                    }
                    maybeNext = currentSeat + i
                    for player in self.game.players where player.seat == maybeNext {
                        if !player.passed {
                            foundNextBetting = true
                            nextBettingPlayer = player.userKey
                        } else {
                            i += 1
                        }
                    }
                }
                DataService.ds.REF_GAMES.child(self.game.tableID).updateChildValues(["betting": nextBettingPlayer])
                betTimer.invalidate()
                isBetting = false
            }
        }
    }
    
    //MARK: - Getting data
    func downloadPlayersData() {
        DataService.ds.REF_GAMES.child(game.tableID).child("players").observe(.value, with: { (snapshot) in
            
            
            self.game.players = []
            self.otherPlayers = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let playerData = snap.value as? [String: AnyObject] {
                        let playerID = snap.key
                        self.downloadPlayerData(withID: playerID, completion: {(success, intermPlayer, error) in
                            
                            if let player = intermPlayer {
                                player.seat = playerData["seat"] as? Int
                                player.stack = playerData["stack"] as? Double
                                self.game.players.append(player)
                            } else {
                                print("ALIBI: \(error.debugDescription)")
                            }
                            
                            for player in self.game.players where player.userKey == currentUserUID {
                                currentSeat = player.seat
                                self.stack = player.stack
                                self.stackLabel.text = "\(player.stack ?? 0.0)"
                            }
                            
                            //Defining otherPlayers array
                            for player in self.game.players where player.seat != currentSeat && player.userKey != currentUserUID {
                                if currentSeat == 1 || currentSeat == self.game.maxPlayers {
                                    if !self.otherPlayers.contains(player) {
                                        self.otherPlayers.append(player)
                                        self.otherPlayers.sort(by: {$0.seat < $1.seat})
                                    }
                                } else {
                                    if self.otherPlayers.isEmpty {
                                        self.otherPlayers.append(player)
                                    } else {
                                        if player.seat > currentSeat {
                                            var i = 0
                                            while player.seat > self.otherPlayers[i].seat, self.otherPlayers[i].seat > currentSeat {
                                                i += 1
                                                if i == self.otherPlayers.count {
                                                    break
                                                }
                                            }
                                            if !self.otherPlayers.contains(player) {
                                                self.otherPlayers.insert(player, at: i)
                                            }
                                        } else if player.seat < currentSeat {
                                            var i = self.otherPlayers.endIndex
                                            while player.seat < self.otherPlayers[i - 1].seat, self.otherPlayers[i - 1].seat < currentSeat {
                                                i -= 1
                                                if i == 0 {
                                                    break
                                                }
                                            }
                                            if !self.otherPlayers.contains(player) {
                                                self.otherPlayers.insert(player, at: i)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            for i in 0..<self.otherPlayers.count {
                                if let image = MainVC.imageCache.object(forKey: self.otherPlayers[i].imageURL as NSString) {
                                    self.otherPlayersSprites[i].playerSat(self.otherPlayers[i], withImage: image)
                                } else {
                                    self.otherPlayersSprites[i].playerSat(self.otherPlayers[i])
                                }
                            }
                            
                            for i in self.otherPlayers.count..<self.otherPlayersSprites.count {
                                self.otherPlayersSprites[i].reset(deckPosition: self.deckOnTable.position)
                            }
                        })
                    }
                }
            }
        })
    }
    
    func downloadPlayerData(withID id: String, completion: @escaping (Bool, Player?, Error?) -> Void) {
        
        DataService.ds.REF_USERS.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userData = snapshot.value as? NSDictionary {
                let playerNickname = userData["nickname"] as! String
                let playerImageURL = userData["imageURL"] as! String
                let playerData = ["nickname": playerNickname,
                                  "imageURL": playerImageURL]
                let player = Player(playerID: id, playerData: playerData as [String: AnyObject])
                completion(true, player, nil)
            }
        }) { (error) in
            completion(false, nil, error)
        }
    }
}
