//
//  CloudRecordFetch.swift
//  MajorStache
//
//  Created by Christopher Martin on 2/27/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import Foundation
import CloudKit

class CloudRecordFetchOperation: CKFetchRecordsOperation{
    
    var fetchedRecords: [CKRecord.ID:CKRecord]

    override init(){
        self.fetchedRecords = [:]
        super.init()
    }
    
    override func main() {
        print("func CloudRecordFetch.main")
        self.setFetchRecordsCompletionBlock()
    }
    
    func setFetchRecordsCompletionBlock(){
        self.fetchRecordsCompletionBlock = {recordDictionary, error in
            
            print("func CloudRecordFetch.setFetchRecordsCompletionBlock")
            
            if error != nil{
                print("Error downloading records: \(error!.localizedDescription)")
            }
            if let records = recordDictionary{
                self.fetchedRecords = records
                let count = self.fetchedRecords.count
                print("\(count)Records downloaded successfully")
            }
        }
    }
}
