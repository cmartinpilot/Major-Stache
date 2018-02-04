//
//  Cabinet+CoreDataClass.swift
//  Stash
//
//  Created by Christopher Martin on 1/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//
//

import UIKit
import CoreData

protocol Orderable {
    var displayOrder:Int16 {get set}
}

@objc(Cabinet)
public class Cabinet: NSManagedObject, Orderable {

}

extension Cabinet: Populatable{
    
    public func populate(with parent: NSManagedObject?){
        
        let png = UIImagePNGRepresentation(#imageLiteral(resourceName: "AddImage.pdf"))
        
        self.dateUpdated = NSDate()
        self.recordID = self.createRecordID()
        self.aircraft = parent as? Aircraft
        self.image = png as NSData?
    }
}
