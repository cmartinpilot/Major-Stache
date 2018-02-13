//
//  AddCabinetItemVC.swift
//  Stash
//
//  Created by Christopher Martin on 2/4/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import UIKit

class AddCabinetItemVC: UIViewController {

    public var dataManager: CoreDataManager?
    public var cabinetItem: CabinetItem?
    public var saveButtonHiddenFlag: Bool = false
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var isAvailableView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.isHidden = self.saveButtonHiddenFlag
        
        self.configureViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let text = self.itemNameTextField.text{
            if text == ""{
                self.cabinetItem?.name = "NO NAME"
            }else{
                self.cabinetItem?.name = text
            }
        }
        if let quantity = self.quantityTextField.text{
            if quantity == ""{
                self.cabinetItem?.quantity = 0
            }else{
                self.cabinetItem?.quantity = Int16(quantity)!
            }
        }
        self.cabinetItem?.isAvailable = self.isAvailableView.isGreen
        
        self.dataManager?.saveData()
    }


    @IBAction func availableCircleTapped(_ sender: Any) {
        print("availableCirlceTapped")
        guard let recognizer = sender as? UITapGestureRecognizer else {return}
        
        if recognizer.state == .ended{
            self.isAvailableView.isGreen = !(self.isAvailableView.isGreen)
        }
    }
    
//MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.itemNameTextField.isFirstResponder {self.itemNameTextField.resignFirstResponder()}
        if self.quantityTextField.isFirstResponder {self.quantityTextField.resignFirstResponder()}
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureViews(){
        
        self.itemNameTextField.text = self.cabinetItem?.name
        if let quantity = self.cabinetItem?.quantity{
            self.quantityTextField.text = "\(quantity)"
        }
        self.isAvailableView.isGreen = (self.cabinetItem?.isAvailable)!
        
        self.itemNameTextField.delegate = self
        self.quantityTextField.delegate = self
    }
}

extension AddCabinetItemVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
