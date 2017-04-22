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
import Foundation
import CoreLocation


class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    // Declarations of View Objects
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dsc: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var addressT: UITextField!
    @IBOutlet weak var addressS: UITextField!
    @IBOutlet weak var elevation: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var distPicker: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var distanceValue: UILabel!
    @IBOutlet weak var bearingValue: UILabel!
    
    var sourceLat:Double?
    var sourceLong:Double?
    var destLat:Double?
    var destLong:Double?
    var distSelectedPlace:String?
    var distV:Double?
    var bearingV:Double?
    var urlString:String = ""
    
    // Radius of Earth
    let R:Double = 6371000.0
    
    //Declaration of Objects and Array Placeholder
    var selectedPlaceName:String = "unknown"
    var placeLib = [String:PlaceDescription]()
    var placeTempObj = PlaceDescription()
    var placeTempSourcelatLong = PlaceDescription()
    var distSelectedPlaceObject = PlaceDescription()
    var placesArray = [String]()
    
    
    
    
    
    
    
    var places: placesDB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        // get the url from info.plist
//        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
//            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
//            self.urlString = ((dict["ServerURLString"]) as?  String!)!
//            // use swift dictionary as normal
//        }
//        
        
        
        
         places  = placesDB()
        
          callGetNPopulatUIFields(selectedPlaceName)
          callGetNamesNUpdateStudentsPicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return placesArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Extract the Latitude and Longitude of the Source and Destination
        sourceLat = placeTempSourcelatLong.latitude
        sourceLong = placeTempSourcelatLong.longitude
        distSelectedPlace = placesArray[row]
        
        getDestLatLong(distSelectedPlace!)
       
    }
    
    
    // Calculate Distance and Bearing
    func calcDistance(sourceLa:Double,sourceLo:Double,destLa:Double,destLo:Double)->(Dist:Double,Bearing:Double){
        
        let phi1 = Measurement(value: sourceLa, unit: UnitAngle.degrees).converted(to: .radians).value
        
        let phi2 = Measurement(value: destLa, unit: UnitAngle.degrees).converted(to: .radians).value
        
        let lambda1 =  Measurement(value: sourceLo, unit: UnitAngle.degrees).converted(to: .radians).value
        
        let lambda2 =  Measurement(value: destLo, unit: UnitAngle.degrees).converted(to: .radians).value
        
        let tempdelphi = destLa - sourceLa
        
        let tempdellambda = destLo - sourceLo
        
        let delphi = Measurement(value: tempdelphi, unit: UnitAngle.degrees).converted(to: .radians).value
        
        let dellambda = Measurement(value: tempdellambda, unit: UnitAngle.degrees).converted(to: .radians).value
        
        let a = sin(delphi/2) * sin(delphi/2) + cos(phi1) * cos(phi2) * sin(dellambda/2) * sin(dellambda/2)
        
        let c = 2 * atan2(sqrt(a),sqrt(1-a))
        
        let d = R * c
        
        let y = sin(lambda2-lambda1) * cos(phi2)
        
        let x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(lambda2 - lambda1)
        
        let tmpbearing = atan2(y,x)
        
        let bearing = Measurement(value: tmpbearing, unit: UnitAngle.radians).converted(to: .degrees).value
        
        return (d,bearing)
        
    }
    
    // Function to be called when the User Edits the existing the Place Object
    @IBAction func Update(_ sender: Any) {

        
        let editedPlace : PlaceDescription = PlaceDescription()
        
        editedPlace.desc = dsc.text!
        editedPlace.name = name.text!
        editedPlace.category = category.text!
        editedPlace.address_street = addressS.text!
        editedPlace.address_title = addressT.text!

        // If the user Edits the value of Latitude,Elevation or Longitude with an invalid value keep the old value and do not change.
        if let tempElev = Double(elevation.text!){
            editedPlace.elevation = tempElev
        }
        if let tempLo = Double (longitude.text!){
            editedPlace.longitude = tempLo
        }

       if let tempLa = Double(latitude.text!){
          editedPlace.latitude = tempLa
        }
        
        places?.updatePlace(addedPlace: editedPlace)
    }
    
    
    
    // Populates the individual place description
    func callGetNPopulatUIFields(_ name: String){
        
         let placeTempObj:PlaceDescription = (places?.getPlaceDetails(placeN: name))!
        
                        self.placeTempSourcelatLong = placeTempObj
                        self.name.text = placeTempObj.name
                        self.dsc.text = placeTempObj.desc
                        self.category.text = placeTempObj.category
                        self.addressT.text = placeTempObj.address_title
                        self.addressS.text = placeTempObj.address_street
                        self.elevation.text = String (placeTempObj.elevation)
                        self.longitude.text = String ( placeTempObj.longitude)
                        self.latitude.text = String ( placeTempObj.latitude)
     
    }
    
//    
//    // Method to add a place to the server
//    func addPlaceToLib(_ editedPlace: PlaceDescription){
//        
//        let jsonData:NSMutableDictionary
//        jsonData = editedPlace.convertToJson(incmomingPlace: editedPlace)
//        let aConnect:PlaceLibrary = PlaceLibrary(urlString: urlString)
//        let resGet:Bool = aConnect.addPlace(name: jsonData, callback: { (res: String, err: String?) -> Void in
//            if err != nil {
//                NSLog(err!)
//            }
//        })
//    }
    
    
    // Method to populate the names in the picker
    func callGetNamesNUpdateStudentsPicker() {
        
       self.placesArray = (places?.getPlaceNames())!
self.distPicker.reloadAllComponents()
            // end of method call to getNames
    }
    
    
    // Method to set the Latitude and Longitude and display the calculated distance and initial bearing
    func getDestLatLong(_ name: String){
        
                        
                        
                                self.distSelectedPlaceObject = (self.places?.getPlaceDetails(placeN: name))!
                                self.destLat = self.distSelectedPlaceObject.latitude
                                self.destLong = self.distSelectedPlaceObject.longitude
                                self.distanceValue.text = String (self.destLat!)
                                self.bearingValue.text = String (self.destLong!)
        
                                self.distV = self.calcDistance(sourceLa: self.sourceLat!, sourceLo: self.sourceLong!, destLa: self.destLat!, destLo:self.destLong!).Dist
                                self.distV = self.distV!/1000
                                self.distanceValue.text = String(format: "%.2f",self.distV!)
                                self.distanceValue.text = self.distanceValue.text! + " Kms"
                                self.bearingV = self.calcDistance(sourceLa: self.sourceLat!, sourceLo: self.sourceLong!, destLa: self.destLat!, destLo:self.destLong!).Bearing
                                self.bearingValue.text = String(format: "%.2f",self.bearingV!)
                                self.bearingValue.text = self.bearingValue.text! + " Degrees"
        
}
}
