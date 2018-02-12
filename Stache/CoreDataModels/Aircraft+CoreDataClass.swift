//
//  Aircraft+CoreDataClass.swift
//  Stash
//
//  Created by Christopher Martin on 1/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Aircraft)
public class Aircraft: NSManagedObject {

}
extension Aircraft: Populatable{

    
    public func populate(with parent: NSManagedObject?) {
    
        self.dateUpdated = NSDate()
        self.recordID = self.createRecordID()
    }
}
