//
//  DataService.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    //MARK: - Properties
    
    //Singleton
    static let ds = DataService()
    
    //Database References
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GAMES = DB_BASE.child("games")
    
    //Storage Reference
    private var _REF_USER_IMAGES = STORAGE_BASE.child("user_images")
    
    //Reference for Database
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    //Reference for Users Database
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    //Reference for Games Database
    var REF_GAMES: DatabaseReference {
        return _REF_GAMES
    }
    //Reference for Current User
    var REF_CURRENT_USER: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    //Reference for the Storage of User Images
    var REF_USER_IMAGES: StorageReference {
        return _REF_USER_IMAGES
    }
    
    //MARK: - Services / Functions
    
    func createDBUser(uid: String, userData: Dictionary<String, AnyObject>) {
        print("ALIBI: Created database user successfully")
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func createGame(gameData: Dictionary<String, AnyObject>) -> Game {
        print("ALIBI: Game successfully created")
        let gameUID = NSUUID().uuidString
        let game = Game(gameID: gameUID, gameData: gameData)
        REF_GAMES.child(gameUID).updateChildValues(["tableName": game.tableName,
                                                    "maxPlayers": game.maxPlayers,
                                                    "private": game.closed,
                                                    "stake": game.stake,
                                                    "players": [currentUserUID: ["seat": 1,
                                                                "stack": 0,
                                                                "isReady" : false]],
                                                    "onGame": game.onGame] as [String : AnyObject])
       
        return game
    }
    
    func checkForInvites(inVC VC: UIViewController, completion: @escaping (Bool, Game?, Error?) -> Void) {
        REF_CURRENT_USER.child("invite").observe(.value, with: { (snapshot) in
            if let invite = snapshot.value as? [String: AnyObject] {
                let tableName = invite["name"] as! String
                let tableID = invite["id"] as! String
                let maxPlayers = invite["maxPlayers"] as! Int
                let inviteAlert = UIAlertController(title: "Incoming Invite", message: "You are invited to the game \(tableName)", preferredStyle: .alert)
                let joinAction = UIAlertAction(title: "Join", style: .default, handler: { (action) in
                    DataService.ds.REF_GAMES.child(tableID).child("players").observeSingleEvent(of: .value, with: { (snaps) in
                        let players = snaps.childrenCount
                         
                        if maxPlayers == players {
                            let fullAlert = UIAlertController(title: "Table is full", message: "There are not any empty seats for you in this game", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            fullAlert.addAction(okAction)
                            VC.present(fullAlert, animated: true, completion: nil)
                        } else {
                            self.REF_CURRENT_USER.child("invite").removeValue()
                            self.REF_GAMES.child(tableID).observeSingleEvent(of: .value, with: { (snapshot) in
                                if let gameData = snapshot.value as? [String: AnyObject] {
                                    let game = Game(gameID: tableID, gameData: gameData)
                                    completion(true, game, nil)
                                }
                            }) { (error) in
                                completion(false, nil, error)
                            }
                        }
                    })
                })
                inviteAlert.addAction(joinAction)
                let rejectAction = UIAlertAction(title: "Reject", style: .destructive, handler: { (action) in
                    self.REF_CURRENT_USER.child("invite").removeValue()
                })
                inviteAlert.addAction(rejectAction)
                VC.present(inviteAlert, animated: true, completion: {
                    Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (timer) in
                        inviteAlert.dismiss(animated: true)
                    })
                })
            }
            
        })
    }
    
    func whereToSeat(inGame gameID: String, completion: @escaping (Bool, Int?, Error?) -> Void) {
        var seat = 1
        REF_GAMES.child(gameID).child("players").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                seat = snapshot.count + 1
                completion(true, seat, nil)
            }
        }) { (error) in
            completion(false, 0, error)
        }
    }
}
