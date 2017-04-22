//
//  PlaceLibrary.swift
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



import Foundation


class PlaceLibrary {
    
    
    static var id:Int = 0
    var url:String
    
    init(urlString: String){
        self.url = urlString
    }
    
    
    // used by methods below to send a request asynchronously.
    // asyncHttpPostJson creates and posts a URLRequest that attaches a JSONRPC request as a Data object
    func asyncHttpPostJSON(url: String,  data: Data,
                           completion: @escaping (String, String?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data
        HTTPsendRequest(request: request, callback: completion)
    }
   
    
    // sendHttpRequest
    func HTTPsendRequest(request: NSMutableURLRequest,
                         callback: @escaping (String, String?) -> Void) {
        // task.resume() below, causes the shared session http request to be posted in the background
        // (independent of the UI Thread)
        // the use of the DispatchQueue.main.async causes the callback to occur on the main queue --
        // where the UI can be altered, and it occurs after the result of the post is received.
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            if (error != nil) {
                callback("", error!.localizedDescription)
            } else {
                DispatchQueue.main.async(execute: {callback(NSString(data: data!,
                                                                     encoding: String.Encoding.utf8.rawValue)! as String, nil)})
            }
        }
        task.resume()
    }

    
    // Get the list of places
    func getNames(callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        //StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"getNames", "params":[ ], "id":1]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    // Get detials of individual places
    func get(name: String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        //StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"get", "params":[name]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       , "id":2]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    // Remove the selected place from the server
    func remove(name: String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        //StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"remove", "params":[name], "id":2]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    // Add the details of a place on the server
    func addPlace(name: NSMutableDictionary, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        //StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"add", "params":[name]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       , "id":2]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
}


