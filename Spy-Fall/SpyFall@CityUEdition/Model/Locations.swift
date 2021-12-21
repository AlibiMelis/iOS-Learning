//
//  Locations.swift
//  SpyFall@CityUEdition
//
//  Created by Alibi on 3/27/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import Foundation

class Locations {
    
    private var _name: String!
    private var _locationRoles: [String]!
    
    var name: String {
        if let name = _name {
            return name
        }
        return ""
    }
    
    var locationRoles: [String] {
//        if let locationRoles = _locationRoles {
//            return locationRoles
//        }
//        return [String]()
        return _locationRoles
    }
    
    func chooseRandomLocation() {
        
        let randomLocation = locationsDB.randomElement()
        self._name = randomLocation?.key
        self._locationRoles = randomLocation?.value
    }
}
