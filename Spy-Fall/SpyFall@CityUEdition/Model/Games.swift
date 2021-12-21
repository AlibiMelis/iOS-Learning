//
//  Games.swift
//  SpyFall@CityUEdition
//
//  Created by Alibi on 3/27/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class Games {
    
    var players = [Players]()
    private var _location: Locations!
    private var _setting: [Int]!
    
    
    var location: Locations {
        if let location = _location {
            return location
        }
        return Locations()
    }
    
    var settings: [Int] {
        if let settings = _setting {
            return settings
        }
        return [Int]()
    }
    
    
    func configureGame(settings: [Int], players: [Players], location: Locations) {
        
        var playersThisGame = players
        var locationRolesThisGame = location.locationRoles
        

        self._location = location
        self._setting = settings
        
        for _ in 0..<settings[1] {
            let spyIndex = Int.random(in: 0..<playersThisGame.count)
            let spy = playersThisGame[spyIndex]
            
            spy.configurePlayer(role: "spy", locationRole: "none")
            self.players.append(spy)
            
            playersThisGame.remove(at: spyIndex)
        }

        for _ in 0..<settings[2] {
            let liarIndex = Int.random(in: 0..<playersThisGame.count)
            let liar = playersThisGame[liarIndex]
            
            let liarLocationRoleIndex = Int.random(in: 0..<locationRolesThisGame.count)
            let liarLocationRole = locationRolesThisGame[liarLocationRoleIndex]
            
            liar.configurePlayer(role: "liar", locationRole: liarLocationRole)
            self.players.append(liar)

            playersThisGame.remove(at: liarIndex)
            locationRolesThisGame.remove(at: liarLocationRoleIndex)
        }

        for _ in 0..<settings[3] {
            let kamikIndex = Int.random(in: 0..<playersThisGame.count)
            let kamik = playersThisGame[kamikIndex]
            
            let kamikLocationRoleIndex = Int.random(in: 0..<locationRolesThisGame.count)
            let kamikLocatioRole = locationRolesThisGame[kamikLocationRoleIndex]
            
            kamik.configurePlayer(role: "kamikadze", locationRole: kamikLocatioRole)
            self.players.append(kamik)
            
            playersThisGame.remove(at: kamikIndex)
            locationRolesThisGame.remove(at: kamikLocationRoleIndex)
        }
        
        for leftPlayer in playersThisGame {
            
            let player = leftPlayer
            let playerLocationRoleIndex: Int
            if locationRolesThisGame.count != 1 {
                playerLocationRoleIndex = Int.random(in: 0..<locationRolesThisGame.count)
            } else {
                playerLocationRoleIndex = 0
            }
            let playerLocationRole = locationRolesThisGame[playerLocationRoleIndex]
            
            player.configurePlayer(role: "player", locationRole: playerLocationRole)
            self.players.append(player)
            
            locationRolesThisGame.remove(at: playerLocationRoleIndex)
        }
        
        self.players.shuffle()
    }

    
}
