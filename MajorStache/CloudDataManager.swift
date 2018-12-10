//
//  CloudDataManager.swift
//  Stache
//
//  Created by Christopher Martin on 2/12/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import Foundation
import CloudKit

protocol QueryType {
}
extension CKQueryOperation.Cursor: QueryType{}
extension CKQuery: QueryType{}

class CloudDataManager{
    
    private let container = CKContainer.default()
    private lazy var database = self.container.publicCloudDatabase
    
    public func fetchChangedRecords(ofType type: String, currentToken: Int64, returnedRecords records: @escaping ([CKRecord?]) -> Void){
        
    }
    
    
    
    private func recordTypeFrom(recordID: CKRecord.ID) -> String?{
        let dotIndex = recordID.recordName.index(of: ".")
        if let index = dotIndex{
            let type = recordID.recordName[..<index]
            return String(type)
        }
        return nil
    }

    
    
    
    private func queryForNewRecordsWith(currentToken: Int64, ofType type: String) -> CKQuery{
        
        let nextTokenNumber = NSNumber(value: currentToken + 1)
        let predicate = NSPredicate(format: "token == %@", nextTokenNumber)
        let query = CKQuery(recordType: type, predicate: predicate)
        
        return query
    }
    
    
}
