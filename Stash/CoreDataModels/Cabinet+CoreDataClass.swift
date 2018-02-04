//
//  Cabinet+CoreDataClass.swift
//  Stash
//
//  Created by Christopher Martin on 1/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//
//

import Foundation
import CoreData

protocol Orderable {
    var displayOrder:Int16 {get set}
}

@objc(Cabinet)
public class Cabinet: NSManagedObject, Orderable {

}


