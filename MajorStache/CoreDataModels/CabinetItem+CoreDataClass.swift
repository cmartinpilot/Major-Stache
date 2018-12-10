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
import CloudKit

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

extension CabinetItem: CKRecordConvertable{
    
    public func convertToCKRecord() -> CKRecord? {
        guard let recordID = self.recordID as? CKRecord.ID,
            let typeString = self.entity.name else {return nil}
        
        let isAvailableString = self.isAvailable.description as NSString
        let quantity = NSNumber(value: self.quantity)
        let displayOrder = NSNumber(value: self.displayOrder)
        
        let record = CKRecord(recordType: typeString, recordID: recordID)
        
        if let name = self.name as NSString?{
            record.setObject(name, forKey: "name")
        }
        record.setObject(self.dateUpdated, forKey: "dateUpdated")
        record.setObject(isAvailableString, forKey: "isAvailable")
        record.setObject(quantity, forKey: "quantity")
        record.setObject(displayOrder, forKey: "displayOrder")
        
        if let cabinet = self.cabinet{
            
            if let recordID = cabinet.recordID as? CKRecord.ID{
                let cabinetReference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                record.setObject(cabinetReference, forKey: "cabinet")
            }
        }
        return record
    }
}
