//
//  ProvinceAdd.swift
//  Purpose - Handles the "add item" workflow
//  This is a standard view controller, modally-presented
//

//  This controller's scene (on the storyboard) must be embedded in a navigation controller

//  This functionality needs a delegate (choose a meaningful name)
//  Therefore, we declare a protocol
//  Example method implementations are at the bottom of this file

import UIKit

protocol AddProvinceDelegate: class {
    
    func addTaskDidCancel(_ controller: UIViewController)
    
    func addTask(_ controller: UIViewController, didSave item: Province)
    // In general, the item type is suggested as Any, which you can cast, or...
    // Recommendation - change the type to match the actual item type
}

class ProvinceAdd: UIViewController {
    
    // MARK: - Instance variables
    
    weak var delegate: AddProvinceDelegate?
    
    // MARK: - Outlets (user interface)
    
    @IBOutlet weak var provinceName: UITextField!
    @IBOutlet weak var provincePremier: UITextField!
    @IBOutlet weak var provinceArea: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Make the provinceName text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        provinceName.becomeFirstResponder()
    }
    
    // MARK: - Actions (user interface)
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Call into the delegate
        delegate?.addTaskDidCancel(self)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        view.endEditing(false)
        errorMessage.text?.removeAll()
        
        // Validate the data before saving
        
        if provinceName.text!.isEmpty {
            errorMessage.text = "Invalid province name"
            return
        }
        
        if provincePremier.text!.isEmpty {
            errorMessage.text = "Invalid premier name"
            return
        }
        
        if provinceArea.text!.isEmpty {
            errorMessage.text = "Invalid area"
            return
        }
        
        // Check numeric value too
        var area: Int = 0
        // Attempt to get the numeric value
        if let value = Int(provinceArea.text!) {
            // Yes, successful, save it for later
            area = value
            // Make one more check, must be a number that makes sense
            if value <= 0 {
                errorMessage.text = "Invalid area"
                return
            }
        }
        
        // If we are here, the data passed the validation tests
        
        // Make an object
        let newItem = Province(name: provinceName.text!, premier: provincePremier.text!, area: area)
        
        // Tell the user what we're doing
        errorMessage.text = "Attempting to save..."
        
        // Call into the delegate
        delegate?.addTask(self, didSave: newItem)
    }
    
}

// Example method implementations
// Copy to the presenting controller's "Lifecycle" area

/*
// Storyboard scene needs a "Cancel" bar button on left side
// Connect it to this method...
func addTaskDidCancel(_ controller: UIViewController) {
    
    dismiss(animated: true, completion: nil)
}

// Storyboard scene needs a "Save" bar button on right side
// Connect it to this method...
func addTask(_ controller: UIViewController, didSave item: Province) {
    // In general, the item type is suggested as Any, which you can cast, or...
    // Recommendation - change the type to match the actual item type
    
    // Attempt to save the new province
    if m.provinceAdd(item) != nil {
        
        dismiss(animated: true, completion: nil)
    }
}
*/
