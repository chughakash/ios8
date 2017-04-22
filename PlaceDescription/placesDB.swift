//
//  placesDB.swift
//  PlaceDescription
//
//  Created by achugh5 on 4/21/17.
//  Copyright © 2017 Arizona State University. All rights reserved.
//

import Foundation
import SQLite


public class placesDB {
    
    var db:Connection?
    var url:URL?
    var _places:Table
    var _placeName:Expression<String>
    var _addressTitle:Expression<String>
    var _addressStreet:Expression<String>
    var _elevation:Expression<Double>
    var _latitude:Expression<Double>
    var _longitude:Expression<Double>
    var _description:Expression<String>
    var _category:Expression<String>

    
    
    
    init(){
        
        self._places = Table("places")
        self._placeName = Expression<String>("place_name")
        self._addressTitle = Expression<String>("titleAdd")
        self._addressStreet = Expression<String>("streetAdd")
        self._elevation = Expression<Double>("elevation")
        self._latitude = Expression<Double>("latitude")
        self._longitude = Expression<Double>("longitude")
        self._description = Expression<String>("description")
        self._category = Expression<String>("category")
       
        self.url = self.getPlaceDBURL()

        do {
            db = try Connection((url?.path)!)
        } catch {
            db = nil
            print("unable to open course db at url: \(String(describing: url))")
        }
        
        
    }
    
    
    
    
    
    func getPlaceNames () -> [String] {
        var placesNam:[String] = []
        do {
            if let anyS:AnySequence<Row> = try db?.prepare(_places) {
                for aCrs in anyS  {
                    placesNam.append(aCrs[_placeName])
                }
            }
        } catch {
            print("unable to get all course names")
        }
        return placesNam
    }
    
    
    
    
    func getPlaceDetails(placeN:String)->PlaceDescription{
        var selectedPlace:PlaceDescription = PlaceDescription()
        
        do{
        if let rows = try db?.prepare(_places.select(_placeName,_addressTitle,_addressStreet,_elevation,_latitude,_longitude,_category,_description).filter(_placeName == placeN))
        {
            
            for aRow in rows{
            
            selectedPlace.name = aRow[_placeName]
            selectedPlace.address_title = aRow[_addressTitle]
            selectedPlace.address_street = aRow[_addressStreet]
            selectedPlace.elevation = aRow[_elevation]
            selectedPlace.latitude = Double(aRow[_latitude])
            selectedPlace.longitude = Double(aRow[_longitude])
            selectedPlace.category = aRow[_category]
            selectedPlace.desc = aRow[_description]
                
            }
            
            
            }
        }catch{}
    
    
    return selectedPlace
    
    }
    
    
    
    
    func addPlace(addedPlace : PlaceDescription) -> Int{
    
        var ret : Int = -1
    let insert = _places.insert(_placeName <- addedPlace.name,_addressStreet <- addedPlace.address_street,_addressTitle <- addedPlace.address_title,_elevation <- addedPlace.elevation,_latitude <- addedPlace.latitude,_longitude <- addedPlace.longitude,_category <- addedPlace.category,
                                _description <- addedPlace.desc)
        
        do{
            if let aRet = try db?.run(insert){
            ret = Int(aRet)
            }
        }catch{}
        
        return ret
    
    }
    
    
    
    func deletePlace(name: String)  -> Int {
        var ret:Int = -1
        do {
            // what if studenttakes table has entry with this course? On delete cascade should
            // remove referencing student takes records. Although explicitly deleted above with
            // delete student, this should not be necessary either.
            let aCrs = _places.filter(_placeName == name)
            if let aRet = try db?.run(aCrs.delete()){
                ret = Int(aRet)
            }
        } catch {
            print("error deleting course \(name)")
        }
        return ret
    }
    
    
    
    
    func updatePlace(addedPlace:PlaceDescription){
    
        
        
        do {
            let row = _places.filter(_placeName == addedPlace.name )
        if let upd = try db?.run(row.update(_addressStreet <- addedPlace.address_street,_addressTitle <- addedPlace.address_title,_elevation <- addedPlace.elevation,_latitude <- addedPlace.latitude,_longitude <- addedPlace.longitude,_category <- addedPlace.category,
                                            _description <- addedPlace.desc)){}
        
       
        }catch{}
        
    }
    
    
    
    

    
   
    
    
    
    
    
    
    
    
    func getPlaceDBURL() -> URL? {
        var ret:URL? = nil
        let fileMgr = FileManager.default
        let urls:[URL] = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        if var docDir:URL = urls.first {
            // This is where the database should be in the documents directory
            docDir.appendPathComponent("placesDB.db")
            if fileMgr.fileExists(atPath: docDir.path) {
                // The database already exists, so return the URL
                ret = docDir
            } else {
                // The database hasn't been copied yet, so copy from the bundle to the documents directory
                if let bundleURL = Bundle.main.url(forResource: "placesDB", withExtension: "db") {
                    do {
                        try fileMgr.copyItem(at: bundleURL, to: docDir)
                    } catch {
                        print("Couldn't copy initial database file to \(docDir.path)")
                    }
                    ret = docDir
                } else {
                    print("Initial database is not in the bundle")
                }
            }
        } else {
            print("Documents directory can not be found")
        }
        return ret
    }
}
