//
//  DataService.swift
//  firebase-sort-data
//
//  Created by Jess Rascal on 06/08/2016.
//  Copyright © 2016 Jess Rascal. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    static let ds = DataService()
    
    var MSGS_DB_REF = DB_BASE.child("messages")
    
}
