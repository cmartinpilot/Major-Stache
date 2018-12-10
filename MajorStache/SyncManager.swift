//
//  SyncManager.swift
//  MajorStache
//
//  Created by Christopher Martin on 3/13/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

class SyncManager{
    
    private let cloudManager: CloudDataManager
    private let coreDataManager: CoreDataManager
    
    public init(cloudManager: CloudDataManager, coreDataManager: CoreDataManager){
        self.cloudManager = cloudManager
        self.coreDataManager = coreDataManager
    }
    
    public func saveRecordsToCloud(added: [CKRecord.ID], updated: [CKRecord.ID], deleted: [CKRecord.ID]){
        //1 Fetch 'added' & 'updated' records from Core Data using CKRecordID
        //2 Create CKRecords for 'added' records
        //3 Fetch 'updated' & 'deleted' records from iCloud
        //4 Update 'updated & 'deleted' records in iCloud
        //5 Create ChangeLog
        //6 Upload ChangeLog
        //7 Increment TokenGenerator
        
    }
    
    //Helpers
    func entityOf(recordID: CKRecord.ID) -> String{
        let name = recordID.recordName
        guard let index = name.index(of: ".") else {return ""}
        let entity = String(name.prefix(upTo: index))
        return entity
    }
}
