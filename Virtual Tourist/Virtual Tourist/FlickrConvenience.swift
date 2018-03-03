//
//  FlickrConvenience.swift
//  Virtual Tourist
//
//  Derrived from work Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//
//  Further devlopment by Jacob Foster Davis in August - September 2016

import UIKit
import Foundation

// MARK: - FlickrClient (Convenient Resource Methods)

extension FlickrClient {
    
    /**
     Connects to Flickr and downloads urls for photos near the given lat and long
     
     - Parameters:
        - lat: Latitude of desired photos
        - long: Longitude of desired photos
        - radius: number of miles from Lat/Long to search
     
     
     - Returns: An array of photos (as dictionaries)
     */
    func getFlickrSearchNearLatLong(_ lat: Double, long: Double, radius: Double = 5.0, completionHandlerForGetFlickrSearchNearLatLong: @escaping (_ results: Any?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters: [String:Any] = [
            FlickrClient.Constants.ParameterKeys.Method: FlickrClient.Constants.Methods.SearchPhotos,
            FlickrClient.Constants.ParameterKeys.Format: FlickrClient.Constants.ParameterValues.ResponseFormat,
            FlickrClient.Constants.ParameterKeys.NoJSONCallback: FlickrClient.Constants.ParameterValues.DisableJSONCallback,
            FlickrClient.Constants.MethodArgumentKeys.PhotosSearch.RadiusUnits: "mi",
            FlickrClient.Constants.MethodArgumentKeys.PhotosSearch.PerPage: 100,
            FlickrClient.Constants.MethodArgumentKeys.PhotosSearch.Page: 1,
            FlickrClient.Constants.MethodArgumentKeys.PhotosSearch.Media: "photos",
            FlickrClient.Constants.MethodArgumentKeys.PhotosSearch.SafeSearch: 1
        ]
        //add passed parameters to parameters dictionary
        //latitude
        parameters[FlickrClient.Constants.MethodArgumentKeys.PhotosSearch.Latitude] = lat
        //longitude
        parameters[FlickrClient.Constants.MethodArgumentKeys.PhotosSearch.Longitude] = long
        //radius
        parameters[FlickrClient.Constants.MethodArgumentKeys.PhotosSearch.Radius] = radius
        
        print("\nAttempting to get Student Locations with the following parameters: ")
        print(parameters)
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForGetFlickrSearchNearLatLong(nil, error)
            } else {
                //json should have returned a A dictionary with a key of "results" that contains an array of dictionaries
                
                if let resultsArray = results?[FlickrClient.Constants.ResponseKeys.Photos] as? [String:AnyObject] { //dig into the JSON response dictionary to get the array at key "photos"
                    
                    print("Unwrapped JSON response from getFlickrSearchNearLatLong:")
                    print (resultsArray)
                    
                    if let photoArray = resultsArray[FlickrClient.Constants.ResponseKeys.Photo] as? [[String:Any]]
                    {
                        print("Array of Photos from getFlickrSearchNearLatLong:")
                        print(photoArray)
//                        //try to put these results into a FlickrPhotoResults struct
                        let flickrResultsObject = FlickrPhotoResults(fromJSONArrayOfPhotoDictionaries: photoArray)
                        completionHandlerForGetFlickrSearchNearLatLong(flickrResultsObject, nil)
                    
                        
                    } else {
                        print("\nDATA ERROR: Could not find \(FlickrClient.Constants.ResponseKeys.Photo) in \(resultsArray)")
                        completionHandlerForGetFlickrSearchNearLatLong(nil, NSError(domain: "getFlickrSearchNearLatLong parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Failed to interpret data returned from Flickr server (getFlickrSearchNearLatLong)."]))
                    }
                    
                } else {
                    print("\nDATA ERROR: Could not find \(FlickrClient.Constants.ResponseKeys.Photos) in \(results)")
                    completionHandlerForGetFlickrSearchNearLatLong(nil, NSError(domain: "getFlickrSearchNearLatLong parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "DATA ERROR: Failed to interpret data returned from Flickr server (getFlickrSearchNearLatLong)."]))
                }
            } // end of error check
        } // end of taskForGetMethod Closure
    } //end getFlickrSearchNearLatLong
}
