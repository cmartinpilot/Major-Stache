//
//  TokenGenerator+CoreDataProperties.swift
//  Stash
//
//  Created by Christopher Martin on 1/25/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//
//

import Foundation
import CoreData


extension TokenGenerator {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TokenGenerator> {
        return NSFetchRequest<TokenGenerator>(entityName: "TokenGenerator")
    }

    @NSManaged public var token: Int64

}
