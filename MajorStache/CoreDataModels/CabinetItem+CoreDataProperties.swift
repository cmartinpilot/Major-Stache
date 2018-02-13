//
//  CabinetItem+CoreDataProperties.swift
//  Stash
//
//  Created by Christopher Martin on 1/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//
//

import Foundation
import CoreData


extension CabinetItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CabinetItem> {
        return NSFetchRequest<CabinetItem>(entityName: "CabinetItem")
    }

    @NSManaged public var isAvailable: Bool
    @NSManaged public var name: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var recordID: NSObject?
    @NSManaged public var dateUpdated: NSDate?
    @NSManaged public var cabinet: Cabinet?
    @NSManaged public var displayOrder: Int16
}
