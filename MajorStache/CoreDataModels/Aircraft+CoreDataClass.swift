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
import CloudKit

@objc(Aircraft)
public class Aircraft: NSManagedObject {

}
extension Aircraft: Populatable{

    
    public func populate(with parent: NSManagedObject?) {
    
        self.dateUpdated = NSDate()
        self.recordID = self.createRecordID()
    }
}

extension Aircraft: CKRecordConvertable{
    
    public func convertToCKRecord() -> CKRecord? {
        guard let recordID = self.recordID as? CKRecordID,
            let typeString = self.entity.name else {return nil}
        
        let record = CKRecord(recordType: typeString, recordID: recordID)
        record.setObject(self.dateUpdated, forKey: "dateUpdated")
        if let tailnumber = self.tailnumber as NSString?{
            record.setObject(tailnumber, forKey: "tailnumber")
        }
        
        return record
    }
}
