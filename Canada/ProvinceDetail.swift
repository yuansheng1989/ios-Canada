//
//  ProvinceDetail.swift
//  Purpose - Shows content for a Detail accessory
//  This is a standard view controller, modally-presented
//

//  This controller's scene (on the storyboard) must be embedded in a navigation controller

//  This functionality needs a delegate (choose a meaningful name)
//  Therefore, we declare a protocol
//  Example method implementations are at the bottom of this file

import UIKit

protocol ShowProvinceDetailDelegate: class {

    func showDetailDone(_ controller: UIViewController)
}

class ProvinceDetail: UIViewController {

    // MARK: - Instance variables
    
    weak var delegate: ShowProvinceDetailDelegate?
    
    // Use if a collection is passed in, or fetched from data model manager
    //var items = [Province]()
    
    // Use if an object MAY be passed in
    //var item: Province?
    // Use if an object WILL be passed in
    var item: Province!
    
    // Use if a reference to the data model manager is passed in
    // If you don't like the variable name, change it
    //var m: DataModelManager!

    // MARK: - Outlets (user interface)

    @IBOutlet weak var provinceName: UILabel!
    @IBOutlet weak var provincePremier: UILabel!
    @IBOutlet weak var provinceArea: UILabel!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        provinceName.text = item.name
        provincePremier.text = "Premier is " + item.premier
        provinceArea.text = "Area is " + String(item.area) + " km"
    }
    
    // MARK: - Actions (user interface)
    
    // This controller's scene has a nav bar button "Done"

    @IBAction func done(_ sender: UIBarButtonItem) {

        // Call into the delegate
        delegate?.showDetailDone(self)
    }

}

// Example method implementations
// Copy to the presenting controller's "Lifecycle" area

/*
// Storyboard scene needs a "Done" bar button on left side
// Connect it to this method...
func showDetailDone(_ controller: UIViewController) {
    
    // Dismiss the "show detail" controller and scene
    dismiss(animated: true, completion: nil)
}
*/
