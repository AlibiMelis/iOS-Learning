//
//  ItemType+CoreDataProperties.swift
//  DreamLister-2
//
//  Created by Alibi on 27.03.2018.
//  Copyright © 2018 Alibi. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
