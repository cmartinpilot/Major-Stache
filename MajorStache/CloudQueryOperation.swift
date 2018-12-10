//
//  CloudQueryOperation.swift
//  MajorStache
//
//  Created by Christopher Martin on 2/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import UIKit
import CloudKit

class CloudQueryOperation: CKQueryOperation {

    var queriedRecords: [CKRecord]
    var queryCursor: CKQueryOperation.Cursor?
    
    convenience init<Type: QueryType>(type: Type) {

        self.init()
        self.queriedRecords = []
        if let query = type as? CKQuery{
            self.query = query
        }
        if let cursor = type as? CKQueryOperation.Cursor{
            self.cursor = cursor
        }
    }
    override init() {
        self.queriedRecords = []
        super.init()
    }
    
    override func main() {
        print("CloudQueryOperation.main")
        self.setRecordFetchedBlock()
        self.setQueryCompletionBlock()
    }
    
    func setRecordFetchedBlock(){
        print("CloudQueryOperation.setRecordFetchedBlock")
        self.recordFetchedBlock = {record in
            self.queriedRecords.append(record)
        }
    }
    
    func setQueryCompletionBlock(){
        print("CloudQueryOperation.setQueryCompletionBlock")
        self.queryCompletionBlock = {cursor, error in
            if error != nil{
                print("Error querying records: \(error!.localizedDescription)")
            }
            if cursor != nil{
                print("Cursor returned")
                self.queryCursor = cursor!
            }
        }
    }
    
}
