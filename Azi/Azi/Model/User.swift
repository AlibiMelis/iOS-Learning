//
//  User.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class User: Comparable {
    
    //MARK: - Properties
    private var _nickname: String!
    private var _imageURL: String!
    private var _userKey: String!
    private var _money: Double!
    private var _gold: Int!
    private var _email: String!
    
    var nickname: String {
        return _nickname
    }
    var imageURL: String {
        return _imageURL
    }
    var userKey: String {
        return _userKey
    }
    var money: Double {
        return _money
    }
    var gold: Int {
        return _gold
    }
    var email: String {
        return _email
    }
    
    //MARK: - Initialiser
    init(userKey: String, userData: Dictionary<String, AnyObject>) {
        self._userKey = userKey
        if let nickname = userData["nickname"] as? String {
            self._nickname = nickname
        }
        if let imageURL = userData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        if let money = userData["money"] as? Double {
            self._money = money
        }
        if let gold = userData["gold"] as? Int {
            self._gold = gold
        }
        if let email = userData["email"] as? String {
            self._email = email
        }
    }
    
    init(friendKey: String, friendData: Dictionary<String, AnyObject>) {
        self._userKey = friendKey
        if let nickname = friendData["nickname"] as? String {
            self._nickname = nickname
        }
        if let imageURL = friendData["imageURL"] as? String {
            self._imageURL = imageURL
        }
    }
    
    //MARK: - Comparable Protocol
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.userKey < rhs.userKey
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userKey == rhs.userKey
    }
}
