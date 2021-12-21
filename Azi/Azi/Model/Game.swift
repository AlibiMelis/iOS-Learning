//
//  Game.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class Game {
    //MARK: - Properties
    private var _tableID: String!
    private var _tableName: String!
    private var _stake: Int!
    private var _maxPlayers: Int!
    private var _closed: String!
    private var _onGame: Bool!
    private var _currentPlayersNum: Int?
    
    var tableID: String {
        return _tableID
    }
    var tableName: String {
        return _tableName
    }
    var stake: Int {
        return _stake
    }
    var maxPlayers: Int {
        return _maxPlayers
    }
    var closed: String {
        return _closed
    }
    var onGame: Bool {
        return _onGame
    }
    var currentPlayersNum: Int {
        if _currentPlayersNum == nil {
            self._currentPlayersNum = 0
        }
        return _currentPlayersNum!
    }
    var players: [Player]!
    
    //MARK: - Initialiser
    init(gameID: String, gameData: Dictionary<String, AnyObject>) {
        
        self._tableID = gameID
        if let tableName = gameData["tableName"] as? String {
            self._tableName = tableName
        }
        if let stake = gameData["stake"] as? Int {
            self._stake = stake
        }
        if let maxPlayers = gameData["maxPlayers"] as? Int {
            self._maxPlayers = maxPlayers
        }
        if let closed = gameData["private"] as? String {
            self._closed = closed
        }
        if let onGame = gameData["onGame"] as? Bool {
            self._onGame = onGame
        }
        if let players = gameData["players"] as? Dictionary<String, AnyObject> {
            self._currentPlayersNum = players.count
        }
    }
}
