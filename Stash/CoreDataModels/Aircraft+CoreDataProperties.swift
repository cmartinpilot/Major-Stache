//
//  Aircraft+CoreDataProperties.swift
//  Stash
//
//  Created by Christopher Martin on 1/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//
//

import Foundation
import CoreData


extension Aircraft {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Aircraft> {
        return NSFetchRequest<Aircraft>(entityName: "Aircraft")
    }

    @NSManaged public var recordID: NSObject?
    @NSManaged public var tailnumber: String?
    @NSManaged public var dateUpdated: NSDate?
    @NSManaged public var cabinets: NSSet?

}

// MARK: Generated accessors for cabinets
extension Aircraft {

    @objc(addCabinetsObject:)
    @NSManaged public func addToCabinets(_ value: Cabinet)

    @objc(removeCabinetsObject:)
    @NSManaged public func removeFromCabinets(_ value: Cabinet)

    @objc(addCabinets:)
    @NSManaged public func addToCabinets(_ values: NSSet)

    @objc(removeCabinets:)
    @NSManaged public func removeFromCabinets(_ values: NSSet)

}
