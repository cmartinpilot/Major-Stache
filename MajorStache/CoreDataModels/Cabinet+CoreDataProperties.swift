//
//  Cabinet+CoreDataProperties.swift
//  Stash
//
//  Created by Christopher Martin on 1/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//
//

import Foundation
import CoreData


extension Cabinet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cabinet> {
        return NSFetchRequest<Cabinet>(entityName: "Cabinet")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var recordID: NSObject?
    @NSManaged public var dateUpdated: NSDate?
    @NSManaged public var aircraft: Aircraft?
    @NSManaged public var cabinetItems: NSSet?
    @NSManaged public var displayOrder: Int16
}

// MARK: Generated accessors for cabinetItems
extension Cabinet {

    @objc(addCabinetItemsObject:)
    @NSManaged public func addToCabinetItems(_ value: CabinetItem)

    @objc(removeCabinetItemsObject:)
    @NSManaged public func removeFromCabinetItems(_ value: CabinetItem)

    @objc(addCabinetItems:)
    @NSManaged public func addToCabinetItems(_ values: NSSet)

    @objc(removeCabinetItems:)
    @NSManaged public func removeFromCabinetItems(_ values: NSSet)

}
