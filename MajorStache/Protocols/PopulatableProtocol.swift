//
//  PopulatableExtension.swift
//  Stash
//
//  Created by Christopher Martin on 2/4/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import Foundation
import CoreData

public protocol Populatable {
    func populate(with parent: NSManagedObject?)
}
