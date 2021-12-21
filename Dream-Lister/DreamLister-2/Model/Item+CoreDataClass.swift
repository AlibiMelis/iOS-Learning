//
//  Item+CoreDataClass.swift
//  DreamLister-2
//
//  Created by Alibi on 27.03.2018.
//  Copyright © 2018 Alibi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        self.created = NSDate()
    }
}
