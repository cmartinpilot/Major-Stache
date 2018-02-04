//
//  CabinetVC.swift
//  Stash
//
//  Created by Christopher Martin on 1/26/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import UIKit
import CoreData

class CabinetVC: UIViewController, CoreDataConforming, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var dataManager: CoreDataManager?
    public var aircraft: Aircraft?
    private var textFields: [UITextField] = []
    private var currentTextField: UITextField? = nil
    private let imagePicker:UIImagePickerController = UIImagePickerController()
    private var cellOfTappedImageView: UITableViewCell? = nil
    fileprivate let fetchRequest: NSFetchRequest<Cabinet> = Cabinet.fetchRequest()
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Cabinet>? = {
        
        guard let moc = self.dataManager?.mainContext else {return nil}
        
        let keyPath = \Cabinet.displayOrder
        let sortDescriptors = NSSortDescriptor(keyPath: keyPath, ascending: true)
        if self.aircraft != nil {
            let predicate = NSPredicate(format: "aircraft == %@", aircraft!)
            self.fetchRequest.predicate = predicate
        }
        
        self.fetchRequest.sortDescriptors = [sortDescriptors]
        
        var controller = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }()

    @IBOutlet weak var tailnumber: UITextField!
    @IBOutlet weak var cabinetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try self.fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Error fetching Cabinets from Core Data. \(error.description)")
        }
        
        self.cabinetTableView.allowsSelection = false
        
        self.imagePicker.delegate = self
        
        self.tailnumber.text = self.aircraft?.tailnumber
        self.tailnumber.delegate = self
        
        self.registerForKeyboardNotifications()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.dataManager?.saveData()
    }
    
    @IBAction func addCabinetTapped(_ sender: Any) {
        
        for field in self.textFields{
            if field.isFirstResponder{field.resignFirstResponder()}
        }
        if self.tailnumber.isFirstResponder{self.tailnumber.resignFirstResponder()}
        
        let results = self.fetchedResultsController?.fetchedObjects
        self.dataManager?.reOrder(fetchedResults: results)
        let newObject = self.dataManager?.createNewObject(type: .cabinet, withParent: self.aircraft)
        if let cabinet = newObject as? Cabinet{
            if let count = self.fetchedResultsController?.fetchedObjects?.count{
                print("Count of fetch results controller items before insert: \(count)")
                cabinet.displayOrder = Int16(count)
            }
            
        }
        
    }
    // MARK: - Image Picker Functions
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        
        //Capture the cell of the tapped imageView
        guard sender.state == .ended,
            let imageView = sender.view,
            let cell = (imageView.superview?.superview as? CabinetCell) else {return}
        
        self.cellOfTappedImageView = cell
        
        self.configureAndPresentImagePicker()
    }
    
    func configureAndPresentImagePicker(){
        self.imagePicker.allowsEditing = false
        self.present(self.imagePicker, animated: true) {}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage]{

            if let cell = self.cellOfTappedImageView as? CabinetCell{
                
                cell.cabinetImageView.image = (image as? UIImage)
                print ("\(String(describing: self.cabinetTableView.indexPath(for: cell)))")
                if let indexPath = self.cabinetTableView.indexPath(for: cell){
                    let cabinet = self.fetchedResultsController?.object(at: indexPath)
                    cabinet?.image = UIImagePNGRepresentation(image as! UIImage)! as NSData
                }
                
            }
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        for field in self.textFields{
            if field.isFirstResponder{field.resignFirstResponder()}
        }
        if self.tailnumber.isFirstResponder{self.tailnumber.resignFirstResponder()}
    }
}

extension CabinetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController?.sections else {return 0}
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cabinetCellReuseID", for: indexPath)
        self.configure(cell: (cell as! CabinetCell), atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: CabinetCell, atIndexPath indexPath: IndexPath){
        guard let cabinet = (self.fetchedResultsController?.object(at: indexPath)) else {return}
        
        cell.cabinetName.text = cabinet.name
        cell.cabinetName.delegate = self
        let alreadyIncluded = self.textFields.contains(where: { (element) -> Bool in
            if (cell.cabinetName) == element{
                return true
            }else{return false}
        })
        if !alreadyIncluded {self.textFields.append(cell.cabinetName)}
        
        if let imageData = cabinet.image{
            let image = UIImage(data: imageData as Data)
            cell.cabinetImageView.image = image
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(CabinetVC.imageTapped(_:)))
        cell.cabinetImageView.addGestureRecognizer(recognizer)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            guard let cabinet = self.fetchedResultsController?.object(at: indexPath) else {return}
            self.dataManager?.delete(object: cabinet)
        }
    }
}

//MARK: - FetchedResultsControllerDelegate
extension CabinetVC: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.cabinetTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("insert cabinet")
            guard let newPath = newIndexPath else {return}
            self.cabinetTableView.insertRows(at: [newPath], with: .automatic)
        case .delete:
            guard let path = indexPath else {return}
            self.cabinetTableView.deleteRows(at: [path], with: .automatic)
        case .update:
            print("update")
            guard let path = indexPath, let cell = self.cabinetTableView.cellForRow(at: path) else {return}
            self.configure(cell: cell as! CabinetCell, atIndexPath: path)
            
        case .move:
            print("Move")
            guard let path = indexPath, let newPath = newIndexPath else {return}
            self.cabinetTableView.deleteRows(at: [path], with: .automatic)
            self.cabinetTableView.insertRows(at: [newPath], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.cabinetTableView.endUpdates()
    }
}
//MARK: - UITextFieldDelegate
extension CabinetVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //If this is a textfield associated with a cell...
        if let cell = (textField.superview?.superview as? CabinetCell){
            
            //Get the indexpath of the cell and use it to grab the correct Cabinet item
            if let indexPath = self.cabinetTableView.indexPath(for: cell){
                let cabinet = self.fetchedResultsController?.object(at: indexPath)
                cabinet?.name = textField.text
            }
            //...otherwise, this is the tailnumber text field.
        }else{
            
            if textField == self.tailnumber {
                if let text = textField.text{
                    self.aircraft?.tailnumber = text
                }else{
                    self.aircraft?.tailnumber = ""
                }
            }
        }
        self.currentTextField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//MARK: - Keyboard Notification
extension CabinetVC{
    
    private func registerForKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        print("KeyboardWasShown")
        
        let cellPadding:CGFloat = 75.0
        
        guard self.currentTextField != self.tailnumber,
            let info = notification.userInfo,
            let keyboardHeight = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let cell = self.currentTextField?.superview?.superview as? CabinetCell,
            let path = self.cabinetTableView.indexPath(for: cell) else {return}
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight + cellPadding, 0.0)
        self.cabinetTableView.contentInset = contentInsets
        self.cabinetTableView.scrollIndicatorInsets = contentInsets
        
        
        self.cabinetTableView.scrollToRow(at: path, at: .bottom, animated: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        print("KeyboardWillHide")
        
        UIView.animate(withDuration: 0.3) {
            self.cabinetTableView.contentInset = UIEdgeInsets.zero
            self.cabinetTableView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }
}
