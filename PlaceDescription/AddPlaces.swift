//
//  AppDelegate.swift
//  PlaceDescription
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
 * Purpose: Assignment submission - 6
 * This example shows the use of multi threading using Async Tasks.
 *
 *
 * Ser423 Mobile Applications
 *
 * @author Akash Chugh      Mailto:Akash.Chugh@asu.edu
 *         Software Engineering,ASU Poly
 * @version March 2017
 */



import UIKit

class AddPlaces: UIViewController, UITextFieldDelegate, UIPickerViewDelegate,
UITableViewDelegate,UINavigationControllerDelegate {
    
    // Declarations
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var ds: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var address_Tit: UITextField!
    @IBOutlet weak var address_Stre: UITextField!
    @IBOutlet weak var elevation: UITextField!
    @IBOutlet weak var lat: UITextField!
    @IBOutlet weak var long: UITextField!
    @IBOutlet weak var Save_But: UIButton!
    var vaddress_title:String?, vaddress_street:String?,vname:String?,vdesc:String?,vcategory:String?
    var velevation:Double?,vlatitude:Double?,vlongitude:Double?
    var placeLib = [String:PlaceDescription]()
    var placesArray = [String]()
    var PlaceDescObj = PlaceDescription()
    let urlString:String = "http://127.0.0.1:8080"
    
    
    
    
    
    var places:placesDB?
    
    override func viewDidLoad() {
        
        // Set Initial Values
        super.viewDidLoad()
        self.vaddress_title = ""
        self.vaddress_street = ""
        self.velevation = 0.00
        self.vlatitude = 0.00
        self.vlongitude = 0.00
        self.vname = ""
        self.vdesc = ""
        self.vcategory = ""
        self.navigationController?.delegate = self
        
        
        places = placesDB()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func add_place(_ sender: Any) {
        
        
        var flagName = false
        
        // If Name is not input by the user or the Name is an invalid name
        self.vname = name.text
        if self.vname == ""
        {
            flagName = false
        }
        else{
            flagName = true
        }
        
        self.vaddress_title = address_Tit.text!
        self.vaddress_street = address_Stre.text
        self.vcategory = category.text
        self.vdesc = ds.text
        
        // Check if the user inputs valid value for Elevation, Latitude and Longitude else set them to zero
        if let tempElevation =  Double((elevation.text)!){
            self.velevation = tempElevation
        }
        if let tempLat =  Double((lat.text)!){
            self.vlatitude = tempLat
        }
        
        if let tempLong =  Double((long.text)!){
            self.vlongitude = tempLong
        }
        
        // If the user inputs a valid Place name
        if flagName{
            PlaceDescObj.name = self.vname!
            
            // Check if the place name already exists.
            if !(placesArray.contains(PlaceDescObj.name)){
                PlaceDescObj.address_title = self.vaddress_title!
                PlaceDescObj.address_street = self.vaddress_street!
                PlaceDescObj.elevation = self.velevation!
                PlaceDescObj.latitude = self.vlatitude!
                PlaceDescObj.longitude = self.vlongitude!
                PlaceDescObj.desc = self.vdesc!
                PlaceDescObj.category = self.vcategory!
                
                let a = places?.addPlace(addedPlace: PlaceDescObj)
                
                
                
               // addPlaceToLib(PlaceDescObj)
                placesArray.append(PlaceDescObj.name)
            }
        }
            // Alert if the user inputs an invalid name
        else{
            
            let alert = UIAlertController(title: "", message: "Please Enter a Valid Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        
        // Pass the Updated back and reload the TableViewUI Controller with the new place added.
        if let controller = viewController as? PlaceLibTableViewController {
            controller.placesArray = self.placesArray
            //controller.placeLibDict = self.placeLib
            controller.tableView.reloadData()
        }
    }
    
    
    func addPlaceToLib(_ editedPlace: PlaceDescription){

        let jsonData:NSMutableDictionary
        jsonData = editedPlace.convertToJson(incmomingPlace: editedPlace)
        let aConnect:PlaceLibrary = PlaceLibrary(urlString: urlString)
        let resGet:Bool = aConnect.addPlace(name: jsonData, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }
        })
    }
}
