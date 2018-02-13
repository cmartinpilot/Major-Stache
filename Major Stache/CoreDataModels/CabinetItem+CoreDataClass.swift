//
//  CabinetItem+CoreDataClass.swift
//  Stash
//
//  Created by Christopher Martin on 1/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//
//

import UIKit
import CoreData

@objc(CabinetItem)
public class CabinetItem: NSManagedObject, Orderable {

}

extension CabinetItem: Populatable{
    
    public func populate(with parent: NSManagedObject?){
        
        self.dateUpdated = NSDate()
        self.recordID = self.createRecordID()
        self.cabinet = parent as? Cabinet
        self.isAvailable = true
        self.quantity = 0
    }
}
