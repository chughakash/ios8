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


import Foundation


class PlaceDescription{
    
    //Declarations
    var address_title:String, address_street:String,name:String,desc:String,category:String
    var elevation:Double,latitude:Double,longitude:Double
    
    
    init(){
        self.address_title = ""
        self.address_street = ""
        self.elevation = 0.00
        self.latitude = 0.00
        self.longitude = 0.00
        self.name = ""
        self.desc = ""
        self.category = ""
        
    }
    

    init(dict: [String:AnyObject]){
        self.address_title = dict["address-title"] as! String
        self.address_street = dict["address-street"] as! String
        self.elevation = dict["elevation"] as! Double
        self.latitude = dict["latitude"] as! Double
        self.longitude = dict["longitude"] as! Double
        self.name = dict["name"] as! String
        self.desc = dict["description"] as! String
        self.category = dict["category"] as! String
    }
    
    
    func convertToJson(incmomingPlace:PlaceDescription)->NSMutableDictionary{
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(incmomingPlace.address_title, forKey:"address-title")
        jsonObject.setValue(incmomingPlace.address_street, forKey:"address-street")
        jsonObject.setValue(incmomingPlace.elevation, forKey:"elevation")
        jsonObject.setValue(incmomingPlace.latitude, forKey:"latitude")
        jsonObject.setValue(incmomingPlace.longitude, forKey:"longitude")
        jsonObject.setValue(incmomingPlace.name, forKey:"name")
        jsonObject.setValue(incmomingPlace.desc, forKey:"description")
        jsonObject.setValue(incmomingPlace.category, forKey:"category")
        
    return jsonObject
        }
}
