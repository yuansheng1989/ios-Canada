//
//  CityScene.swift
//  Purpose - Control the "next" scene in the nav Disclosure workflow
//  This is a standard view controller
//  It is within a navigation workflow, with a presenter, and a successor
//

import UIKit

class CitySceneBase: UIViewController {
    
    // MARK: - Instance variables
    
    // Use if a collection is passed in, or fetched from data model manager
    //var items = [City]()
    
    // Use if an object MAY be passed in
    //var item: City?
    // Use if an object WILL be passed in
    var item: City!
    
    // Use if a reference to the data model manager is passed in
    // If you don't like the variable name, change it
    var m: DataModelManager!
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityMayor: UILabel!
    @IBOutlet weak var cityPopulation: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cityName.text = item.name
        cityMayor.text = "Mayor is " + item.mayor
        cityPopulation.text = "Population is " + String(item.population)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update the user interface
        //item = m.cityById(item.id)
        //title = item.name
    }
    
    // MARK: - Actions (user interface)
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Add "if" blocks to cover all the possible segues
        // One for each workflow (navigation) or task segue
        
        // A workflow segue is managed by the current nav controller
        // A task segue goes to a scene that's managed by a NEW nav controller
        // So there's a difference in how we get a reference to the next controller
        
        // Example workflow segue code...
        /*
        if segue.identifier == "toWorkflowScene" {
            
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is managed by the current nav controller
            let vc = segue.destination as! CityScene
            
            // Fetch and prepare the data to be passed on
            let selectedData = item
            
            // Set other properties
            vc.item = selectedData
            vc.title = selectedData?.name
            // Pass on the data model manager, if necessary
            //vc.m = m
            // Set the delegate, if configured
            //vc.delegate = self
        }
        */
        
        // Example task segue code...
        /*
        if segue.identifier == "toTaskScene" {
            
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is embedded in a new navigation controller
            // so we must go through it
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! CityDetail
            
            // Fetch and prepare the data to be passed on
            let selectedData = item
            
            // Set other properties
            vc.item = selectedData
            vc.title = selectedData?.name
            // Pass on the data model manager, if necessary
            //vc.m = m
            // Set the delegate, if configured
            //vc.delegate = self
        }
        */
        
    }
    
}
