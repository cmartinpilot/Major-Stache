//
//  CoreDataStack.swift
//  Stash
//
//  Created by Christopher Martin on 1/25/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import Foundation
import CoreData

//MARK: - Protocol
protocol CoreDataConforming{
    var dataManager:CoreDataManager? {get set}
}
// MARK: - Class Definition
class CoreDataStack{
    
    private let modelName:String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var privateContext:NSManagedObjectContext = {
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        privateContext.persistentStoreCoordinator = self.persistantStoreCoordinator
        
        return privateContext
    }()
    
    public private(set) lazy var mainContext:NSManagedObjectContext = {
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        context.parent = privateContext
        
        return context
    }()
    
    private lazy var managedObjectModel:NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {return nil}
        
        let mom = NSManagedObjectModel(contentsOf: modelURL)
        
        return mom
    }()
    
    private lazy var persistentStoreURL:URL = {
        let storeName = "\(self.modelName).sqlite"
        let fileManager = FileManager.default
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectoryURL.appendingPathComponent(storeName)
    }()
    
    private lazy var persistantStoreCoordinator:NSPersistentStoreCoordinator? = {
    
        guard let managedObjectModel = self.managedObjectModel else {return nil}
        
        let persistentStoreURL = self.persistentStoreURL
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do{
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
        }catch let error as NSError{
            print("Error adding persistant store: \(error.description)")
        }
        return persistentStoreCoordinator
    }()
    
    //MARK: - Save
    //Write data to the persistant store
    public func savePrivateContext(){
        
        self.privateContext.perform {
            
            guard self.privateContext.hasChanges == true else {return}
        
            do{
                try self.privateContext.save()
            }catch let error as NSError{
                print("Error saving Private Context: \(error.description)")
            }
        }
    }
    
    
}



