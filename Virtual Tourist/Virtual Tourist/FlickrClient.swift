//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Derrived from work Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//
//  Further devlopment by Jacob Foster Davis in August - September 2016

import Foundation
import UIKit

// MARK: - ParseClient: NSObject

class FlickrClient : NSObject {
    
    // MARK: Shared Instance
    static let sharedInstance = FlickrClient()
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    //Set a pointer to the shared data model
//    var StudentInformations: [StudentInformation]{
//        return StudentInformationsModel.sharedInstance.StudentInformations
//    }
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(parameters: [String:Any], completionHandlerForGET: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var passTheseParameters = parameters
        //add the APIKey
        passTheseParameters[Constants.ParameterKeys.API_key] = Constants.ApiKey as AnyObject?
        //add the URL extra
        passTheseParameters[Constants.ParameterKeys.Extras] = Constants.ParameterValues.MediumURL as AnyObject?
        
        // No API key passed in this m
        //parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: FlickrURLFromParameters(passTheseParameters, withPathExtension: nil))
//        request.addValue(Secrets.FlickrAPIKey, forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue(Secrets.FlickrRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, code: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!.localizedDescription, code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code other than 2xx! Status code \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 3)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForGETImage(filePath: String, completionHandlerForGETImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        //none
        
        var url = URL(string: filePath)
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: url!)
        //        request.addValue(Secrets.FlickrAPIKey, forHTTPHeaderField: "X-Parse-Application-Id")
        //        request.addValue(Secrets.FlickrRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        print("Starting task for URL: \(request.url!)")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, code: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETImage(nil, NSError(domain: "taskForGETImage", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!.localizedDescription, code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                switch (response as? HTTPURLResponse)!.statusCode {
                default:
                    sendError("Your request returned a status code other than 2xx! Status code \((response as? HTTPURLResponse)!.statusCode).", code: 2)
                }
                
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 3)
                return
            }
            
            /* 5/6. return data */
            completionHandlerForGETImage(data, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func subtituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        //let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) //don't need to this for Parse
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "\nDATA CONVERT ERROR: Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 4, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    fileprivate func FlickrURLFromParameters(_ parameters: [String:Any]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        print("About to return a URL: " + (components.url?.absoluteString)!)
        return components.url!
    }
    
}
