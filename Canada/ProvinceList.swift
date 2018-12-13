//
//  ProvinceList.swift
//  Purpose - Shows content for a collection, in a table view
//  This is a table view controller
//  Can be used anywhere in the navigation workflow (start, mid, end)
//

import UIKit

// Adopt the protocols that are appropriate for this controller

class ProvinceListBase: UITableViewController, AddProvinceDelegate, ShowProvinceDetailDelegate {
    
    // MARK: - Instance variables
    
    // Use if a collection is passed in, or fetched from data model manager
    var items = [Province]()
    
    // Use if an object MAY be passed in
    //var item: Province?
    // Use if an object WILL be passed in
    //var item: Province!
    
    // Use if a reference to the data model manager is passed in
    // If you don't like the variable name, change it
    var m: DataModelManager!
    
    // MARK: - Outlets (user interface)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the locally-defined instance variable for the collection
        items = m.provinces
        // Alternatives...
        items = m.provincesSortedById()
        items = m.provincesSortedByName()
        
        // Set a title here or on the storyboard scene
        title = "Provinces"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // We must refresh the data in the table view
        // First, refresh the data source
        items = m.provincesSortedByName()
        // Then, ask the table view to reload itself
        tableView.reloadData()
    }
    
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
    
    // Storyboard scene needs a "Done" bar button on left side
    // Connect it to this method...
    func showDetailDone(_ controller: UIViewController) {
        
        // Dismiss the "show detail" controller and scene
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view building
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // For many apps done in the DPS923/MAP523 course, there is one (1) section
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // Get this value from the "count" of the collection that's used in the table view
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // #warning Match the value "cell" with the value used on the prototype cell attributes inspector in the storyboard editor
        
        // Configure the cell...
        
        // Get the object we want
        let item = items[indexPath.row]
        
        // Configure the UI objects
        cell.textLabel?.text = item.name
        //cell.detailTextLabel?.text = item.maker
        // etc.
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            // Remember that the table view "data source" is NOT the same
            // as the table view "rows"
            
            // First, get the row data, so we can get its identifier
            let item = m.provinces[indexPath.row]
            
            // Next, attempt to delete the item from the data source
            if m.provinceDelete(item.id) {
                // Yes, successful, so continue...
                // Refresh the data source
                items = m.provincesSortedByName()
                // Remove the row
                tableView.deleteRows(at: [indexPath], with: .fade)
                // Reload the table view
                tableView.reloadData()
            }
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
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
        
        if segue.identifier == "toCityList" {
            
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is managed by the current nav controller
            let vc = segue.destination as! CityListBase
            // Alternative... next controller is a table view controller
            //let vc = segue.destination as! ProvinceList
            
            // Fetch and prepare the data to be passed on
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = items[indexPath!.row]
            
            // Set other properties
            vc.selectedProvince = selectedData
            vc.title = selectedData.name
            // Pass on the data model manager, if necessary
            vc.m = m
            // Set the delegate, if configured
            //vc.delegate = self
        }
        
        
        // Example task segue code...
        
        if segue.identifier == "toProvinceAdd" {
            
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is embedded in a new navigation controller
            // so we must go through it
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! ProvinceAdd
            
            // Fetch and prepare the data to be passed on
            //let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            //let selectedData = items[indexPath!.row]
            
            // Set other properties
            //vc.item = selectedData
            //vc.title = selectedData.name
            // Pass on the data model manager, if necessary
            //vc.m = m
            // Set the delegate, if configured
            vc.delegate = self
        }
        
        if segue.identifier == "toProvinceDetail" {
            
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is embedded in a new navigation controller
            // so we must go through it
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! ProvinceDetail
            
            // Fetch and prepare the data to be passed on
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = items[indexPath!.row]
            
            // Set other properties
            vc.item = selectedData
            vc.title = selectedData.name
            // Pass on the data model manager, if necessary
            //vc.m = m
            // Set the delegate, if configured
            vc.delegate = self
        }
        
        
    }
    
}
