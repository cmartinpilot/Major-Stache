//
//  AircraftTableVC.swift
//  Stash
//
//  Created by Christopher Martin on 1/25/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import UIKit
import CoreData

class AircraftTableVC: UITableViewController, CoreDataConforming {
    
    
    
    var dataManager: CoreDataManager?
    let fetchRequest:NSFetchRequest<Aircraft> = Aircraft.fetchRequest()
    fileprivate lazy var fetchedResultsController:NSFetchedResultsController<Aircraft>? = {
        
        guard let moc = self.dataManager?.topScratchPadPage else {return nil}
        let fetchRequest:NSFetchRequest<Aircraft> = Aircraft.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(keyPath: \Aircraft.tailnumber, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try self.fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Error fetching Aircraft from Core Data. \(error.description)")
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController?.sections?.count else{return 0}
        return sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController?.sections else {return 0}
        return sections[section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "aircraftCellReuseID", for: indexPath)
        
        self.configure(cell: (cell as! AircraftCell), atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: AircraftCell, atIndexPath indexPath: IndexPath){
        guard let aircraft = (self.fetchedResultsController?.object(at: indexPath)) else {return}
        cell.tailnumber.text = aircraft.tailnumber
    }
 
    //MARK: - Deletes
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let aircraft = (self.fetchedResultsController?.object(at: indexPath)) else {return}
            self.dataManager?.topScratchPadPage.delete(aircraft)
        }
    }
    
     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueIdentifier = segue.identifier,
            let cabinetController = segue.destination as? CabinetVC else {return}
        
        self.dataManager?.beginScratchPadPage()
        cabinetController.dataManager = self.dataManager
        
        switch segueIdentifier {
        case "addAircraftSegue":
            let newAircraft = self.dataManager?.createNewObject(type: .aircraft, withParent: nil)
            cabinetController.aircraft = newAircraft as? Aircraft
        case "selectAircraftSegue":
            guard let indexPath = self.tableView.indexPathForSelectedRow else {return}
            let aircraft = (self.fetchedResultsController?.object(at: indexPath))
            let newContextObject = self.dataManager?.objectInOldPageFoundInNew(objectInOldPage: aircraft!)
            cabinetController.aircraft = newContextObject as? Aircraft
        default:
            print("Segue undefined")
        }
    }
    
    
    //MARK: - Unwind
    @IBAction func unwindFromCabinetVC(sender: UIStoryboardSegue){

        self.dataManager?.saveData()
        
        self.dataManager?.endScratchPadPage()
    }

    @IBAction func unwindFromCabinetVCCancel(sender: UIStoryboardSegue){
        
        self.dataManager?.endScratchPadPage()
    }
    
}

//MARK: - FetchedResultsControllerDelegate
extension AircraftTableVC: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        

        switch type {
        case .insert:
            guard let newPath = newIndexPath else {return}
            self.tableView.insertRows(at: [newPath], with: .automatic)
        case .delete:
            guard let path = indexPath else {return}
            self.tableView.deleteRows(at: [path], with: .automatic)
        case .update:
            print("update")
            guard let path = indexPath, let cell = self.tableView.cellForRow(at: path) else {return}
            self.configure(cell: cell as! AircraftCell, atIndexPath: path)
            self.tableView.reloadRows(at: [path], with: .automatic)
        case .move:
            print("Move")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
