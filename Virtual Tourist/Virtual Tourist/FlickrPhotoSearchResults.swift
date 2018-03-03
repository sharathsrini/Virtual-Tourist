//
//  FlickrPhotoSearchResults.swift
//  Virtual Tourist
//
//  Created by Jacob Foster Davis on 10/6/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation

struct FlickrPhotoResults {
    
    var photos = [FlickrPhotoResult]()
    
    enum FlickrPhotoResultsError: Error {
        case badInput
    }
    
    init?(fromJSONArrayOfPhotoDictionaries data: [[String:Any]]) {
        for photoDictionary in data {
            
            do {
                if let newFlickrPhoto = try FlickrPhotoResult(fromDataSet: photoDictionary) {
                    photos.append(newFlickrPhoto)
                }
            } catch {
                print("Error FlickrPhotoResults: could not assign flickrphoto ")
                return nil
            }
            
        }
    }
    
    func count() -> Int {
        return photos.count
    }
}
