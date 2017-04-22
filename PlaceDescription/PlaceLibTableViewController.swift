//
//  PlaceLibTableViewController.swift
//  PlaceDescription
//
/*
 * Copyright 2017 Akash Chugh,
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * Right to Use :Can be used by Arizona State University and the faculty staff.
 *
 *
 * Purpose: Assignment submission - 4
 * This example shows the use of various controllers, navigation control and segue.
 *
 *
 * Ser423 Mobile Applications
 *
 * @author Akash Chugh      Mailto:Akash.Chugh@asu.edu
 *         Software Engineering,ASU Poly
 * @version March 2017
 */


import UIKit

class PlaceLibTableViewController: UITableViewController {
    
    // Declarations
    var placeLibDict = [String:PlaceDescription]()
    var allEntries = [[String:Any]]()
    var placesArray = [String()]
    var urlString:String = ""
    
     var places: placesDB?

    
    var placeSel :PlaceDescription?
    
    private var tb: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       places  = placesDB()
        
        
        self.placesArray = (places?.getPlaceNames())!
        placeSel = PlaceDescription()
        
        
        
        
//        self.title = "Places Arena"
//        
//        // get the url from info.plist
//        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
//            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
//            self.urlString = ((dict["ServerURLString"]) as?  String!)!
//            // use swift dictionary as normal
//        }
        
//        let NorthAmerica = PlaceLibrary(urlString: urlString)
//        
//      //  let controller = viewController as? PlaceLibTableViewController
//        self.callGetNamesNUpdateStudentsPicker()
//        placesArray.remove(at:0)
        
        
        
    
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // return the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return placesArray.count
        
    }
    
      // Configure the cell and place custom values for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Place", for: indexPath)
        cell.textLabel?.text = placesArray[indexPath.row]
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedPlace:String = self.placesArray[indexPath.row]
            
            places?.deletePlace(name: deletedPlace)
            self.placesArray.remove(at:indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
           // removePlaceNUpdate(deletedPlace,indexPath)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If one of the place cells is clicked.
        if segue.identifier == "ShowPlaceDetails" {
            let viewController:ViewController = segue.destination as! ViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            viewController.selectedPlaceName = self.placesArray[indexPath.row]
            
            
            
            
          //  placeSel = places?.getPlaceDetails(placeName: viewController.selectedPlaceName)
            
            
  
        }
        
        // If the plus sign at the navigation controller is clicked
        if segue.identifier == "AddPlace"{
            let newView = segue.destination as! AddPlaces
            newView.placesArray = self.placesArray
        }
    }
    
    
  
}

