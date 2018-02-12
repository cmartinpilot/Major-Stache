//
//  CabinetItemVC.swift
//  Stash
//
//  Created by Christopher Martin on 2/2/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import UIKit
import CoreData

class CabinetItemVC: UIViewController {

    public var dataManager: CoreDataManager?
    public var cabinet: Cabinet?
   
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<CabinetItem>? = {
        
        let sortDescriptors = NSSortDescriptor(keyPath: \CabinetItem.displayOrder, ascending: true)
        var predicate: NSPredicate? = nil
        if self.cabinet != nil {
            predicate = NSPredicate(format: "cabinet == %@", cabinet!)
        }
        
        var controller:NSFetchedResultsController<CabinetItem>? = (self.dataManager?.fetchedResultsController(sortDescriptors: [sortDescriptors], predicate: predicate, delegate: self))
        
        return controller
    }()
    
    @IBOutlet weak var cabinetImageView: UIImageView!
    @IBOutlet weak var cabinetItemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupImage()
    }

    
    private func setupImage(){
        
        guard let imageData = self.cabinet?.image,
            let image = UIImage(data: imageData as Data) else {return}
        self.cabinetImageView.image = image
    }

    
     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AddCabinetItemVC else {return}
        destination.dataManager = self.dataManager
        
        if segue.identifier == "addCabinetItemSegueID"{
            
            let results = self.fetchedResultsController?.fetchedObjects
            self.dataManager?.reOrder(fetchedResults: results)
            
            let newObject = self.dataManager?.createNew(object: CabinetItem.self, withParent: self.cabinet)
            
            if let newCabinetItem = newObject{
                if let count = self.fetchedResultsController?.fetchedObjects?.count{
                    print("Count of fetch results controller items before insert: \(count)")
                    newCabinetItem.displayOrder = Int16(count)
                    destination.cabinetItem = newCabinetItem
                    destination.saveButtonHiddenFlag = false
                }
            }
        }
        if segue.identifier == "cabinetItemSelectedSegueID"{
            guard let indexPath = self.cabinetItemsTableView.indexPathForSelectedRow,
                let selectedCabinetItem = self.fetchedResultsController?.object(at: indexPath) else {return}
            destination.cabinetItem = selectedCabinetItem
            destination.saveButtonHiddenFlag = true
            
            self.cabinetItemsTableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension CabinetItemVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController?.sections else {return 0}
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cabinetItemCellReuseID", for: indexPath)
        self.configure(cell: (cell as! CabinetItemCell), atIndexPath: indexPath)
        return cell
    }
    
    func configure(cell: CabinetItemCell, atIndexPath indexPath: IndexPath){
        guard let cabinetItem = (self.fetchedResultsController?.object(at: indexPath)),
            let circleView = cell.quantityAnnunciatorView as? CircleView else {return}
        
        cell.cabinetItemNameLabel.text = cabinetItem.name
        circleView.text = "\(cabinetItem.quantity)"
        circleView.isGreen = cabinetItem.isAvailable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            guard let cabinetItem = self.fetchedResultsController?.object(at: indexPath) else {return}
            self.dataManager?.delete(object: cabinetItem)
        }
    }
}

//MARK: - FetchedResultsControllerDelegate
extension CabinetItemVC: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.cabinetItemsTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("insert cabinet")
            guard let newPath = newIndexPath else {return}
            self.cabinetItemsTableView.insertRows(at: [newPath], with: .automatic)
        case .delete:
            guard let path = indexPath else {return}
            self.cabinetItemsTableView.deleteRows(at: [path], with: .automatic)
        case .update:
            print("update")
            guard let path = indexPath, let cell = self.cabinetItemsTableView.cellForRow(at: path) else {return}
            self.configure(cell: cell as! CabinetItemCell, atIndexPath: path)
            
        case .move:
            print("Move")
            guard let path = indexPath, let newPath = newIndexPath else {return}
            self.cabinetItemsTableView.deleteRows(at: [path], with: .automatic)
            self.cabinetItemsTableView.insertRows(at: [newPath], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.cabinetItemsTableView.endUpdates()
    }
}

