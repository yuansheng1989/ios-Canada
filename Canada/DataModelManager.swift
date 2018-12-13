//
//  DataModelManager.swift
//  Purpose - Is the data model manager module/controller for the app
//

//  There is commented-out code at the bottom of this file
//  It enables the initialization and configuration of the data model manager
//  in the app delegate class

import Foundation

class DataModelManager {
    
    // MARK: - Data properties
    var provinces = [Province]()
    
    // MARK: - Initializers
    
    init() {
        
        // Load the saved plist
        loadPlist()
        
        // First time loaded?
        if provinces.count == 0 {
            provinces.append(Province(name: "Ontario", premier: "Doug Ford", area: 1076000))
            provinces.append(Province(name: "Nova Scotia", premier: "Stephen McNeil", area: 55284))
            
            for i in 0..<provinces.count {
                provinces[i].id = i + 1
            }
        }
    }
    
    // MARK: - Private methods
    
    private func nextProvinceId() -> Int {
        
        // Look for the maximum "id" value, and return the next usable value
        return provinces.reduce(0, { max($0, $1.id) }) + 1
    }
    
    private func nextCityId(_ provinceId: Int) -> Int? {
        
        if let province = provinceById(provinceId) {
            return province.cities.reduce(0, { max($0, $1.id) }) + 1
        }
        // If the above statement fails, we return nil, which is appropriate
        return nil
    }
    
    private func provinceIndexById(_ id: Int) -> Int? {
        
        // Look for the index of the desired item
        return provinces.index(where: {$0.id == id})
    }
    
    private func appDataFilePath() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Optional (for learning, inspection, and troubleshooting)
        //print(paths[0])
        return paths[0].appendingPathComponent("appdata.plist")
    }
    
    // MARK: - Public methods
    
    func savePlist() {
        let encoder = PropertyListEncoder()
        do {
            let provinceData = try encoder.encode(provinces)
            try provinceData.write(to: appDataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array")
        }
    }
    
    func loadPlist() {
        if let data = try? Data(contentsOf: appDataFilePath()) {
            let decoder = PropertyListDecoder()
            do {
                provinces = try decoder.decode([Province].self, from: data)
            } catch {
                print("Error decoding item array")
            }
        }
    }
    
    func provinceById(_ id: Int) -> Province? {
        
        // Search for matching identifier
        return provinces.first(where: {$0.id == id})
    }
    
    func cityById(_ provinceId: Int, _ cityId: Int) -> City? {
        if let province = provinceById(provinceId) {
            // do stuff, and return the city object
            return province.cities.first(where: {$0.id == cityId})
        }
        // If the above statement fails, we return nil, which is appropriate
        return nil
    }
    
    func citiesByid(_ provinceId: Int) -> [City]? {
        if let province = provinceById(provinceId) {
            return province.cities
        }
        return nil
    }
    
    func provinceByName(_ name: String) -> Province? {
        
        // Clean and prepare the name first
        let cleanName = name.trimmingCharacters(in: .whitespaces).lowercased()
        // Search for matching name
        return provinces.first(where: {$0.name.lowercased() == cleanName})
    }
    
    func provinceAdd(_ newItem: Province) -> Province? {
        
        // Attempt to add the new item, by verifying non-null data
        // Data should ALSO be validated in the user interface controller that gets the data from the user
        // Doing it here too is done for code/data safety
        if !newItem.name.isEmpty && !newItem.premier.isEmpty && newItem.area > 0 {
            // Set the value of "id"
            newItem.id = nextProvinceId()
            // Save it to the collection
            provinces.append(newItem)
            return provinces.last
        }
        return nil
    }
    
    func cityAdd(_ provinceId: Int, _ newItem: City) -> City? {
        if let province = provinceById(provinceId) {
            if !newItem.name.isEmpty && !newItem.mayor.isEmpty && newItem.population > 0 {
                // Set the value of "id"
                newItem.id = nextCityId(province.id)!
                // Save it to the collection
                province.cities.append(newItem)
                return province.cities.last
            }
            return nil
        }
        return nil
    }
    
    func provinceEdit(_ editedItem: Province) -> Province? {
        
        // Attempt to locate the item
        if let index = provinces.index(where: {$0.id == editedItem.id}) {
            
            // Attempt to update the existing item, by verifying non-null data
            // Data should ALSO be validated in the user interface controller that gets the data from the user
            // Doing it here too is done for code/data safety
            if !editedItem.name.isEmpty && !editedItem.premier.isEmpty && editedItem.area > 0 {
                // Save it to the collection
                provinces[index] = editedItem
                return provinces[index]
            }
        }
        return nil
    }
    
    func provinceDelete(_ id: Int) -> Bool {
        
        // Attempt to locate the item
        if let item = provinceIndexById(id) {
            // Yes, has been located, so remove the item
            provinces.remove(at: item)
            return true
        }
        return false
    }
    
    func provincesSortedById() -> [Province] {
        
        // Sort the array; include a comparison function
        let sortedProvinces = provinces.sorted(by: { (p1: Province, p2: Province) -> Bool in return p1.id < p2.id })
        
        return sortedProvinces
    }
    
    func citiesSortedById(_ provinceId: Int) -> [City] {
        if let province = provinceById(provinceId) {
            let sortedCities = province.cities.sorted(by: { (p1: City, p2: City) -> Bool in return p1.id < p2.id })
            return sortedCities
        }
        return []
    }
    
    func provincesSortedByName() -> [Province] {
        
        // Sort the array; include a comparison function
        let sortedProvinces = provinces.sorted(by: { (p1: Province, p2: Province) -> Bool in return p1.name.lowercased() < p2.name.lowercased() })
        
        return sortedProvinces
    }
    
    func citiesSortedByName(_ provinceId: Int) -> [City] {
        if let province = provinceById(provinceId) {
            let sortedCities = province.cities.sorted(by: { (p1: City, p2: City) -> Bool in return p1.name.lowercased() < p2.name.lowercased() })
            return sortedCities
        }
        return []
    }
}

// Add the following statement...
// m.savePlist()
// ...to these methods in the app delegate class:
// func applicationDidEnterBackground(_ application: UIApplication)
// func applicationWillTerminate(_ application: UIApplication)

// Then...

// The code below must be pasted into the app delegate class
// There are two versions:
// 1. When a table view controller manages the first scene
// 2. When a standard view controller manages the first scene

// Copy the code below, and REPLACE the app delegate method
// application(didFinishLaunchingWithOptions:)

/*
// For use when a table view controller manages the first scene
// In this situation, the storyboard entry point is a navigation controller
 
// Create the data model manager
let m = DataModelManager()

// MARK: - Lifecycle

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Get a reference to the navigation controller
    let nav = window!.rootViewController as! UINavigationController
    
    // Get a reference to the (table view) controller
    let tvc = nav.viewControllers[0] as! ProductList
    
    // Pass the model object to the (table view) controller
    tvc.m = m
    
    return true
}
*/

/*
 // For use when a standard view controller manages the first scene
 // In this situation, the storyboard entry point is NOT a navigation controller

 // Create the data model manager
 let m = DataModelManager()
 
 // MARK: - Lifecycle
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
 // Get a reference to the (standard view) controller
 let tvc = nav.rootViewController as! ProductStartView
 
 // Pass the model object to the (standard view) controller
 tvc.m = m
 
 return true
 }
 */
