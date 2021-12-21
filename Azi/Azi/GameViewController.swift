//
//  GameViewController.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Firebase
import PureLayout

class GameViewController: UIViewController, UITableViewDelegate {
    //MARK: - Variables
    var game: Game! {
        didSet {
            currentGame = game.tableID
        }
    }
    
    let scene = GameScene(size: CGSize(width: 768, height: 1024))
    
    let tableView = UITableView()
    var friends = [User]()
    var setStackView = SetStack()
    let backView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.gray
        bv.alpha = 0.4
        return bv
    }()
    var betView = BetView()

    //MARK: - View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self

        let skView = self.view as! SKView

        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        scene.size = skView.bounds.size
        scene.vc = self
        scene.game = game
        
        skView.presentScene(scene)
        scene.isUserInteractionEnabled = false
        
        skView.addSubview(backView)
        backView.autoPinEdgesToSuperviewEdges()
        backView.isUserInteractionEnabled = false
        skView.addSubview(setStackView)
        setStackView.autoSetDimension(.width, toSize: 260)
        setStackView.autoCenterInSuperview()
        setStackView.configureStackView(inGame: game)
        setStackView.isHidden = false
        
        skView.addSubview(betView)
        betView.isHidden = true
        betView.autoPinEdge(.bottom, to: .bottom, of: skView, withOffset: -125)
        betView.autoPinEdge(.trailing, to: .trailing, of: skView, withOffset: 20)
        betView.autoSetDimensions(to: CGSize(width: 120, height: 200))
        
        setupTableView(inView: skView)
        friendList()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Functions
    
    func bet(round: Int, amount: Double?) {
        
        var betAmount: Double {
            if amount == nil {
                return betView.getBetAmount()
            } else {
                return amount!
            }
        }
        
        DataService.ds.REF_GAMES.child(game.tableID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let gameData = snapshot.value as? [String: AnyObject] {
                if let pot = gameData["pot"] as? Double {
                    let newPot = pot + betAmount
                    DataService.ds.REF_GAMES.child(self.game.tableID).updateChildValues(["pot": newPot])
                } else {
                    DataService.ds.REF_GAMES.child(self.game.tableID).updateChildValues(["pot": betAmount])
                }
            }
        })
        DataService.ds.REF_GAMES.child(game.tableID).child("players").child("stack").observeSingleEvent(of: .value, with: { (snapshot) in
            if let stack = snapshot.value as? Double {
                print("ALIBI: Getting bet from stack")
                let newStack = stack - betAmount
                DataService.ds.REF_GAMES.child(self.game.tableID).child("players").updateChildValues(["stack": newStack])
            }
        })
        DataService.ds.REF_GAMES.child(game.tableID).child("betData").child("\(round)").updateChildValues([currentUserUID: "\(betAmount)"])
        
        betView.isHidden = true
    }
    
    func showBetView(minBet: Double, maxBet: Double) {
        betView.configureBetView(minBet: minBet, maxBet: maxBet)
        betView.isHidden = false
    }
    
    func addFriends() {
        tableView.isHidden = false
    }
    
    func setupTableView(inView view: SKView) {
        view.addSubview(tableView)
        let inset = UIEdgeInsets(top: 320, left: 100, bottom: 320, right: 100)
        tableView.autoPinEdgesToSuperviewEdges(with: inset)
        tableView.isHidden = true
        tableView.rowHeight = 65
        tableView.register(InviteFriendCell.self, forCellReuseIdentifier: "cell")
    }
    
    func friendList() {
        DataService.ds.REF_CURRENT_USER.child("friends").observe(.value, with: {(snapshot) in
            
            self.friends = []
            if let friends = snapshot.value as? Dictionary<String, Bool> {
                for friend in friends.keys {
                    DataService.ds.REF_USERS.child(friend).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let friendData = snapshot.value as? [String: AnyObject] {
                            let friendUser = User(friendKey: friend, friendData: friendData)
                            self.friends.append(friendUser)
                        }
                        self.friends.sort()
                        self.tableView.reloadData()
                    })
                }
            }
        })
    }
    
    func inviteFriendToGame(_ friend: User) {
        
        print("ALIBI: Invited friend \(friend.nickname)")
        DataService.ds.REF_USERS.child(friend.userKey).updateChildValues(["invite": ["id": game.tableID,
                                                                             "name": game.tableName,
                                                                             "maxPlayers": game.maxPlayers]])
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (timer) in
            DataService.ds.REF_USERS.child(friend.userKey).child("invite").removeValue()
        })
    }
}

extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friends.isEmpty {
            return 0
        } else {
            return friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? InviteFriendCell {
            cell.configureInviteFriendCell(ofFriend: friends[indexPath.row])
            return cell
        } else {
            return InviteFriendCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ALIBI: Selected friend to invite")
        inviteFriendToGame(friends[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
