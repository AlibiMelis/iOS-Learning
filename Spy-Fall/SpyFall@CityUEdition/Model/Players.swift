//
//  Players.swift
//  SpyFall@CityUEdition
//
//  Created by Alibi on 3/27/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class Players {
    
    private var _name: String!
    private var _role: String!
    private var _locationRole: String!

    var name: String {
        if let name = _name {
            return name
        }
        return ""
    }

    var role: String {
        if let role = _role {
            return role
        }
        return ""
    }

    var locationRole: String {
        if let locationRole = _locationRole {
            return locationRole
        }
        return ""
    }
    
    func configurePlayer(role: String, locationRole: String) {
        
        self._role = role
        self._locationRole = locationRole
    }
    
    init(name: String) {
        self._name = name
    }
}
