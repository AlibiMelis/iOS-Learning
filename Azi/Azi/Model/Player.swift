//
//  Player.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class Player: Equatable {
    
    //MARK: - Properties
    private var _nickname: String!
    private var _imageURL: String!
    private var _userKey: String!
    private var _isReady: Bool!
    private var _passed: Bool!
    
    var stack: Double!
    var seat: Int!
    var hand: [String: String]!
    var isReady: Bool {
        return _isReady
    }
    var nickname: String {
        return _nickname
    }
    var imageURL: String {
        return _imageURL
    }
    var userKey: String {
        return _userKey
    }
    var passed: Bool {
        if _passed == nil {
            _passed = false
        }
        return _passed
    }
    
    //MARK: - Initialiser
    init(playerID: String, playerData: Dictionary<String, AnyObject>) {
        
        self._userKey = playerID
        if let stack = playerData["stack"] as? Double {
            self.stack = stack
        }
        if let seat = playerData["seat"] as? Int {
            self.seat = seat
        }
        if let isReady = playerData["isReady"] as? Bool {
            self._isReady = isReady
        }
        if let nickname = playerData["nickname"] as? String {
            self._nickname = nickname
        }
        if let imageURL = playerData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        if let passed = playerData["passed"] as? Bool {
            self._passed = passed
        }
        self.hand = [:]
    }
    
    //MARK: - Equatable Protocol
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.userKey == rhs.userKey
    }
}
