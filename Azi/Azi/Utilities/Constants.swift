//
//  Constants.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

let KEY_UID = "uid"
let currentUserUID = KeychainWrapper.standard.string(forKey: KEY_UID)!
var currentSeat = Int()
var currentGame = String()

func whereToSeat(inGame game: Game) {
    DataService.ds.whereToSeat(inGame: game.tableID, completion: { (success, seat, error) in
        DataService.ds.REF_GAMES.child(game.tableID).child("players").updateChildValues([currentUserUID: ["seat": seat!,
        "stack": 0,
        "isReady": false]])
        currentSeat = seat!
        if error != nil {
            print("ALIBI: Couldn't add player to game with error \(error.debugDescription)")
        }
    })
}
