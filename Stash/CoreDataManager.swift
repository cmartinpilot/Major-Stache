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

typealias ScratchPadPage = NSManagedObjectContext

class CoreDataManager{
    
    private let stack: CoreDataStack
    private var scratchPad: [ScratchPadPage] = []
    public lazy var topScratchPadPage: ScratchPadPage = self.stack.mainContext
    
    
    public init(stack: CoreDataStack) {
        self.stack = stack
    }
    
    //MARK: - Public accessors
    public func beginScratchPadPage(){
        
        let page = self.scratchpadpage()
        self.push(page: page)
        print("BeginScratchPadPage.  Page count \(self.scratchPad.count)")
        self.topScratchPadPage = self.scratchPad.first!
    }
    
    public func objectInOldPageFoundInNew(objectInOldPage object: NSManagedObject) -> NSManagedObject{
        
        let id = object.objectID
        return self.topScratchPadPage.object(with: id)
    }
    
    public func endScratchPadPage(){
        
        guard self.scratchPad.count > 0 else {return}
        self.pop()
        print("EndScratchPadPage.  Page count \(self.scratchPad.count)")
        self.topScratchPadPage = self.scratchPad.first ?? self.stack.mainContext
    }
    
    public func createNewObject(type: ModelType, withParent parent: NSManagedObject?) -> NSManagedObject{
        
        switch type{
        case .aircraft:
            let aircraft = Aircraft(context: self.topScratchPadPage)
            aircraft.dateUpdated = NSDate()
            aircraft.recordID = self.createRecordID(forType: type)
            return aircraft
        case .cabinet:
            
            let png = UIImagePNGRepresentation(#imageLiteral(resourceName: "AddImage.pdf"))
            
            let cabinet = Cabinet(context: self.topScratchPadPage)
            cabinet.aircraft = parent as? Aircraft
            cabinet.dateUpdated = NSDate()
            cabinet.image = png as NSData?
            cabinet.recordID = self.createRecordID(forType: type)
            return cabinet
        case .cabinetItem:
            let cabinetItem = CabinetItem(context: self.topScratchPadPage)
            cabinetItem.cabinet = parent as? Cabinet
            cabinetItem.isAvailable = true
            cabinetItem.quantity = 0
            cabinetItem.dateUpdated = NSDate()
            cabinetItem.recordID = self.createRecordID(forType: type)
            return cabinetItem
        }
    }
    
    public func delete(object: NSManagedObject){
        
        self.topScratchPadPage.delete(object)
        
    }
    
    public func saveData(){
        
        if self.scratchPad.count > 0 {
            
            for page in self.scratchPad{
                page.performAndWait({
                    
                    guard page.hasChanges == true else {return}
                    
                    do{
                        try page.save()
                    }catch let error as NSError{
                        print("Error saving Scratchpad page: \(error.description)")
                    }
                    
                })
            }
        }
        
        self.stack.mainContext.performAndWait {
            
            guard self.stack.mainContext.hasChanges == true else {return}
            
            do{
                try self.stack.mainContext.save()
            }catch let error as NSError{
                print("Error saving Main Context: \(error.description)")
            }
        }
        
        self.stack.savePrivateContext()
    }
    
    func reOrder(fetchedResults: [NSManagedObject]?){
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
    
    
    //MARK: - Private ScratchPad Stack
    private func push(page: ScratchPadPage){
        
        if self.scratchPad.count > 0{
            page.parent = self.scratchPad.first
            self.scratchPad.insert(page, at: 0)
        }else{
            page.parent = self.stack.mainContext
            self.scratchPad.insert(page, at: 0)
        }
    }
    
    private func pop(){
        self.scratchPad.removeFirst()
    }
    //MARK: - Private helpers
    private func scratchpadpage() -> ScratchPadPage{
        let page = ScratchPadPage(concurrencyType: .mainQueueConcurrencyType)
        return page
    }
    
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
