//
//  CoreDataManager.swift
//  Stash
//
//  Created by Christopher Martin on 1/30/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import UIKit
import CoreData
import CloudKit


class CoreDataManager{
    
    private let stack: CoreDataStack
    public lazy var mainContext:NSManagedObjectContext = self.stack.mainContext
    
    
    public init(stack: CoreDataStack) {
        self.stack = stack
    }
    
    //MARK: - Public accessors

    
    public func createNewObject(type: ModelType, withParent parent: NSManagedObject?) -> NSManagedObject{
        
        switch type{
        case .aircraft:
            let aircraft = Aircraft(context: self.mainContext)
            aircraft.dateUpdated = NSDate()
            aircraft.recordID = self.createRecordID(forType: type)
            return aircraft
        case .cabinet:
            
            let png = UIImagePNGRepresentation(#imageLiteral(resourceName: "AddImage.pdf"))
            
            let cabinet = Cabinet(context: self.mainContext)
            cabinet.aircraft = parent as? Aircraft
            cabinet.dateUpdated = NSDate()
            cabinet.image = png as NSData?
            cabinet.recordID = self.createRecordID(forType: type)
            return cabinet
        case .cabinetItem:
            let cabinetItem = CabinetItem(context: self.mainContext)
            cabinetItem.cabinet = parent as? Cabinet
            cabinetItem.isAvailable = true
            cabinetItem.quantity = 0
            cabinetItem.dateUpdated = NSDate()
            cabinetItem.recordID = self.createRecordID(forType: type)
            return cabinetItem
        }
    }
    
    public func delete(object: NSManagedObject){
        
        self.mainContext.delete(object)
        
    }
    
    public func saveData(){
        
        self.mainContext.performAndWait {
            
            guard self.mainContext.hasChanges == true else {return}
            
            do{
                try self.mainContext.save()
            }catch let error as NSError{
                print("Error saving Main Context: \(error.description)")
            }
        }
        
        self.stack.savePrivateContext()
    }
    
    public func reOrder(fetchedResults: [NSManagedObject]?){
        guard fetchedResults != nil,
            let results = fetchedResults,
            results.count > 0 else {return}
        
        var i = 0
        results.forEach({ (object) in
            if var orderCapableObject = object as? Orderable{
                orderCapableObject.displayOrder = Int16(i)
                i = i + 1
            }
        })
        
        
        
        
    }
    
    //MARK: - RecordID creator helper
    private func createRecordID(forType type: ModelType) -> CKRecordID{
        
        let typeString = type.rawValue
        let uuid = UUID().uuidString
        let seperator = "."
        
        let combinedString = typeString + seperator + uuid
        print("Created recordID: \(combinedString) for type \(type)")
        let recordID = CKRecordID(recordName: combinedString)
        return recordID
    }

    
}
