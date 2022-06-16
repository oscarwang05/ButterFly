//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Milo on 16/06/2022.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var active_flag: Bool
    @NSManaged public var item_id: Int64
    @NSManaged public var last_updated: String?
    @NSManaged public var last_updated_user_entity_id: Int64
    @NSManaged public var product_item_id: Int64
    @NSManaged public var quantity: Int64
    @NSManaged public var transient_identifier: Int64
    @NSManaged public var order: PurchaseOrder?

}
