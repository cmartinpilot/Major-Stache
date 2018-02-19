//
//  CoreDataManager.swift
//  Stash
//
//  Created by Christopher Martin on 1/30/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import UIKit
import CoreData


class CoreDataManager{
    
    private let stack: CoreDataStack

    public init(stack: CoreDataStack) {
        self.stack = stack
    }
    
    public lazy var currentToken: Int64? = {
        let request:NSFetchRequest<TokenGenerator> = TokenGenerator.fetchRequest()
        
        do{
            let fetchedGenerator =  try self.stack.mainContext.fetch(request)
            guard fetchedGenerator.count > 0,
                let firstGenerator = fetchedGenerator.first else {return nil}
            return Int64(firstGenerator.token)
        }catch let error as NSError{
            print("Error fetching token: \(error.description)")
            return nil
        }
    }()
    
    //MARK: - Public accessors

    public func fetchedResultsController<Result: NSFetchRequestResult, Delegate: NSFetchedResultsControllerDelegate>(sortDescriptors:[NSSortDescriptor], predicate: NSPredicate?, delegate: Delegate) -> NSFetchedResultsController<Result>{
        
        let moc = self.stack.mainContext
        
        let fetchRequest:NSFetchRequest<Result> = NSFetchRequest(entityName: String(describing: Result.self))
        fetchRequest.sortDescriptors = sortDescriptors
        if predicate != nil{
            fetchRequest.predicate = predicate!
        }
        
        let controller = NSFetchedResultsController<Result>(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = delegate
        
        do {
            try controller.performFetch()
            print("Fetch resluts count: \(String(describing: controller.fetchedObjects?.count))")
        } catch let error as NSError {
            print("Error fetching Aircraft from Core Data. \(error.description)")
        }
        
        return controller
    }
    public func createNew<Object: NSManagedObject>(object: Object.Type, withParent parent: NSManagedObject?) -> Object where Object: Populatable{
        
        let newObject = Object(context: self.stack.mainContext)
        newObject.populate(with: parent)
        
        return newObject
        
    }
    
    
    public func delete(object: NSManagedObject){
        
        self.stack.mainContext.delete(object)
        self.saveData()
    }
    
    public func saveData(){
        
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
}
