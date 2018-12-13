//
//  CityAdd.swift
//  Purpose - Handles the "add item" workflow
//  This is a standard view controller, modally-presented
//

//  This controller's scene (on the storyboard) must be embedded in a navigation controller

//  This functionality needs a delegate (choose a meaningful name)
//  Therefore, we declare a protocol
//  Example method implementations are at the bottom of this file

import UIKit

protocol AddCityDelegate: class {
    
    func addTaskDidCancel(_ controller: UIViewController)
    
    func addTask(_ controller: UIViewController, didSave item: City)
    // In general, the item type is suggested as Any, which you can cast, or...
    // Recommendation - change the type to match the actual item type
}

class CityAdd: UIViewController {
    
    // MARK: - Instance variables
    
    weak var delegate: AddCityDelegate?
    
    // MARK: - Outlets (user interface)
    
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var cityMayor: UITextField!
    @IBOutlet weak var cityPopulation: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Make the cityName text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityName.becomeFirstResponder()
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
        
        if cityName.text!.isEmpty {
            errorMessage.text = "Invalid city name"
            return
        }
        
        if cityMayor.text!.isEmpty {
            errorMessage.text = "Invalid mayor name"
            return
        }
        
        if cityPopulation.text!.isEmpty {
            errorMessage.text = "Invalid population"
            return
        }
        
        // Check numeric value too
        var population: Int = 0
        // Attempt to get the numeric value
        if let value = Int(cityPopulation.text!) {
            // Yes, successful, save it for later
            population = value
            // Make one more check, must be a number that makes sense
            if value <= 0 {
                errorMessage.text = "Invalid population"
                return
            }
        }
        
        // If we are here, the data passed the validation tests
        
        // Make an object
        let newItem = City(name: cityName.text!, mayor: cityMayor.text!, population: population)
        
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
func addTask(_ controller: UIViewController, didSave item: City) {
    // In general, the item type is suggested as Any, which you can cast, or...
    // Recommendation - change the type to match the actual item type
    
    // Attempt to save the new city
    if m.cityAdd(item) != nil {
        
        dismiss(animated: true, completion: nil)
    }
}
*/
