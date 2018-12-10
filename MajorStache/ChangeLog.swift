//
//  ChangeLog.swift
//  MajorStache
//
//  Created by Christopher Martin on 3/16/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import Foundation
import CloudKit


class ChangeLog{
    
    private var changeToken: Int64
    private var adds: [CKRecord.ID]?
    private var updates: [CKRecord.ID]?
    private var deletes: [CKRecord.ID]?
    
    
    public init(changeToken: Int64, adds: [CKRecord.ID]?, updates: [CKRecord.ID]?, deletes: [CKRecord.ID]?) {
        self.changeToken = changeToken
        self.adds = adds
        self.updates = updates
        self.deletes = deletes
    }
    
    
}
