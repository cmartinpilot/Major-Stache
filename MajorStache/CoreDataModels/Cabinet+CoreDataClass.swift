//
//  Cabinet+CoreDataClass.swift
//  Stash
//
//  Created by Christopher Martin on 1/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//
//

import UIKit
import CoreData
import CloudKit

protocol Orderable {
    var displayOrder:Int16 {get set}
}

@objc(Cabinet)
public class Cabinet: NSManagedObject, Orderable {

}

extension Cabinet: Populatable{
    
    public func populate(with parent: NSManagedObject?){
        
        let png = UIImagePNGRepresentation(#imageLiteral(resourceName: "AddImage.pdf"))
        
        self.dateUpdated = NSDate()
        self.recordID = self.createRecordID()
        self.aircraft = parent as? Aircraft
        self.image = png as NSData?
    }
}

extension Cabinet: CKRecordConvertable{
    
    public func convertToCKRecord() -> CKRecord? {
        guard let recordID = self.recordID as? CKRecordID,
            let typeString = self.entity.name else {return nil}
        
        let record = CKRecord(recordType: typeString, recordID: recordID)
        record.setObject(self.dateUpdated, forKey: "dateUpdated")
        if let name = self.name as NSString?{
            record.setObject(name, forKey: "name")
        }
        if let image = self.image{
            record.setObject(image, forKey: "image")
        }
        if let aircraft = self.aircraft{
            
            if let recordID = aircraft.recordID as? CKRecordID{
                let aircraftReference = CKReference(recordID: recordID, action: .deleteSelf)
                record.setObject(aircraftReference, forKey: "aircraft")
            }
        }
        
        let displayOrder = NSNumber(value: self.displayOrder)
        record.setObject(displayOrder, forKey: "displayOrder")
        
        return record
    }
}
