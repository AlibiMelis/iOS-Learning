//
//  Item+CoreDataProperties.swift
//  DreamLister-2
//
//  Created by Alibi on 27.03.2018.
//  Copyright © 2018 Alibi. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var title: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var price: String?
    @NSManaged public var toImage: Image?
    @NSManaged public var toItemType: ItemType?
    @NSManaged public var toStore: Store?

}
