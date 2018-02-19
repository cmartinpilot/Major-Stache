//
//  CKRecordConvertableProtocol.swift
//  MajorStache
//
//  Created by Christopher Martin on 2/16/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import Foundation
import CloudKit

protocol CKRecordConvertable {
    func convertToCKRecord() -> CKRecord?
}
