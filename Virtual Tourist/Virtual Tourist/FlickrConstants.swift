//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Derrived from work Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//
//  Further devlopment by Jacob Foster Davis in October 2016

// MARK: - ParseClient (Constants)

extension FlickrClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Keys
        static let ApiKey : String = Secrets.FlickrAPIKey
        static let RESTApiKey : String = Secrets.FlickrRESTAPIKey
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
        //static let APIBaseURL = "https://api.flickr.com/services/rest/"
   
    
        // MARK: Methods
        struct Methods {
            
            //MARK: Getting Photos
            static let SearchPhotos = "flickr.photos.search"
            
            
        }
        
        struct MethodArgumentKeys {
            struct PhotosSearch {
                static let Sort = "sort"
                static let Accuracy = "accuracy"
                static let SafeSearch = "safe_search"
                static let ContentType = "content_type"
                static let HasGeo = "has_geo"
                static let GeoContext = "geo_context"
                static let Latitude = "lat"
                static let Longitude = "lon"
                static let Radius = "radius"
                static let RadiusUnits = "radius_units"
                static let PerPage = "per_page"
                static let Page = "page"
                static let Media = "media"
            }
        }
        
        
        // MARK: Parameter Keys
        struct ParameterKeys {
            
            static let Method = "method"
            static let API_key = "api_key"
            static let Extras = "extras"
            static let Format = "format"
            static let NoJSONCallback = "nojsoncallback"
        }
        
        struct ParameterValues {
            static let MediumURL = "url_m"
            static let ResponseFormat = "json"
            static let DisableJSONCallback = "1" /* 1 means "yes" */
        }
        
        struct ResponseKeys {
            static let Status = "stat"
            static let Photos = "photos"
            static let Photo = "photo"
            static let Title = "title"
            static let MediumURL = "url_m"
        }
        
    }
}
