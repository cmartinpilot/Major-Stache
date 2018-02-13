//
//  NSManagedObjectExtension.swift
//  Stash
//
//  Created by Christopher Martin on 2/4/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

extension NSManagedObject{
    
    public func createRecordID() -> CKRecordID{
        
        let typeString:String? = self.entity.name ?? "NilObject"
        let uuid = UUID().uuidString
        let seperator = "."
        
        let combinedString = typeString! + seperator + uuid
        print("Created recordID: \(combinedString) for type \(typeString!))")
        let recordID = CKRecordID(recordName: combinedString)
        return recordID
    }
}
