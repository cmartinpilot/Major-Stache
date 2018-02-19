//
//  CloudDataManager.swift
//  Stache
//
//  Created by Christopher Martin on 2/12/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import Foundation
import CloudKit

class CloudDataManager{
    
    public func fetchChangedRecords(ofType type: String, currentToken: Int64, returnedRecords records: ([CKRecord?]) -> Void){
        
    }
    
    private func queryBasedOnCurrentToken(currentToken: Int64, ofType type: String) -> CKQuery{
        
        let nextTokenNumber = NSNumber(value: currentToken + 1)
        
        let predicate = NSPredicate(format: "token == %@", nextTokenNumber)
        
        let query = CKQuery(recordType: type, predicate: predicate)
        
        
        
    }
    
}
