//
//  FlickrPhoto.swift
//  Virtual Tourist
//
//  Created by Jacob Foster Davis on 10/6/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import Foundation

/**
 A single photo result from Flickr JSON.
 */

struct FlickrPhotoResult {
    
    /******************************************************/
    /******************* Properties **************/
    /******************************************************/
    //MARK: - Properties
    var farm : Int?
    var height : Int?
    var id : Int?
    var isFamily: Bool?
    var isFriend: Bool?
    var isPublic: Bool?
    var owner: String?
    var secret: String?
    var server: Int?
    var title: String?
    var url: String?
    var width: Int?
    
    /********************************************/
    /******************* Error Checking Properties **************/
    /********************************************/
    // MARK: Error Checking Properties
    /// A Set that contains the JSON keys expected from the server.  Used to check input and check for errors or unexpected input
    let expectedKeys : Set<String> = ["farm", "height_m", "id", "isfamily", "isfriend", "ispublic", "owner", "secret", "server", "title", "url_m", "width_m"]
    
    // Error Cases
    /*
     *  Used to throw errors
     */
    enum FlickrPhotoKeyError: Error {
        case badInputKeys(keys: [String]) //couldn't convert incoming dictionary keys to a set of Strings
        case inputMismatchKeys(keys: Set<String>) //incoming keys don't match expected keys
    }
    enum FlickrPhotoAssignmentError: Error {
        case badInputValues(property: String)
        case inputValueOutOfExpectedRange(expected: String, actual: Double)
    }
    
    /********************************************/
    /******************* Initialization **************/
    /********************************************/
    // MARK: - Initialization Options
    /*
     *  Can init with fromDataSet (recommended) or without any parameters
     */
    init?(fromDataSet data: [String:Any]) throws {
        //print("\nAttempting to initialize StudentInformation Object from data set")
        
        //try to stuff the data into the properties of this instance, or return nil if it doesn't work
        //check the keys first
        do {
            try checkInputKeys(data)
        } catch FlickrPhotoKeyError.badInputKeys (let keys){
            print("\nERROR: Data appears to be malformed. BadInputKeys:")
            print(keys)
            return nil
        } catch FlickrPhotoKeyError.inputMismatchKeys(let keys) {
            print("\nERROR: InputMismatchKeys. Data appears to be malformed. These keys: ")
            print(keys)
            print("Do not match the expected keys: ")
            print(expectedKeys)
            return nil
        } catch {
            print("\nSTUDENT INFORMATION ERROR: Unknown error when calling checkInputKeys")
            return nil
        }
        
        //keys look good, now try to assign the values to the struct
        do {
            try attemptToAssignValues(data)
            //print("Successfully initialized a StudentInformation object\n")
        } catch FlickrPhotoAssignmentError.badInputValues(let propertyName) {
            print("\nSTUDENT INFORMATION ERROR: FlickrPhotoAssignmentError: bad input when parsing ")
            print(propertyName)
            return nil
        } catch FlickrPhotoAssignmentError.inputValueOutOfExpectedRange(let expected, let actual) {
            print("\nSTUDENT INFORMATION ERROR: A value was out of the expected range when calling attemptToAssignValues.  Expected: \"" + expected + "\" Actual: " + String(actual))
            return nil
        }catch {
            print("\nSTUDENT INFORMATION ERROR: Unknown error when calling attemptToAssignValues")
            return nil
        }
    }
    
    //init withiout a data set
    init() {
        //placeholder to allow struct to be initialized without input parameters
    }
    
    /********************************************/
    /******************* Input Checking **************/
    /********************************************/
    // MARK: - Input Checking
    /*
     *  Called during init to ensure data meets all validation requirements
     */
    
    /**
     Verifies that the keys input match the expected keys
     
     - Parameters:
     - data: a `[String:AnyObject]` containing key-value pairs that match `expectedKeys`
     
     - Returns:
     - True: if keys match
     
     - Throws:
     - `FlickrPhotoKeyError.BadInputKeys` if input keys can't be made into a set
     - `FlickrPhotoKeyError.InputMismatchKeys` if input keys don't match `expectedKeys`
     */
    func checkInputKeys(_ data: [String:Any]) throws -> Bool {
        //guard check one: Put the incoming keys into a set
        
        let keysToCheck = [String](data.keys) as? [String]
        //print("About to check these keys against expected: " + String(keysToCheck))
        //check to see if incoming keys can be placed into a set of strings
        guard let incomingKeys : Set<String> = keysToCheck.map(Set.init) else {
            throw FlickrPhotoKeyError.badInputKeys(keys: [String](data.keys))
        }
        
        //compare the new set with the expectedKeys
        guard incomingKeys == self.expectedKeys else {
            throw FlickrPhotoKeyError.inputMismatchKeys(keys: incomingKeys)
        }
        
        //print("The following sets appear to match: ")
        //print(self.expectedKeys)
        //print(keysToCheck!)
        
        //Keys match
        return true
    }
    
    /**
     Attempts to take a `[String:AnyObject]` and assign it to all of the properties of this struct
     
     - Parameters:
     - data: a `[String:AnyObject]` containing key-value pairs that match `expectedKeys`
     
     - Returns:
     - True: if all values are assigned successfully
     
     - Throws:
     - `FlickrPhotoAssignmentError.BadInputValues` if input doesn't have a key in the `expectedKeys` Set
     - `FlickrPhotoAssignmentError.inputValueOutOfExpectedRange` if input value at a key that has an expected range is out of range
     */
    private mutating func attemptToAssignValues(_ data: [String:Any]) throws -> Bool {
        
        //go through each item and attempt to assign it to the struct
        //print("\nAbout to assign values from the following object: ")
        //print(data)
        
        for (key, value) in data {
            switch key {
                
            case "farm":
                if let value = value as? Int {
                    farm = value
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "farm")
                }
            case "height_m":
                if let valueString = value as? String, let valueInt = Int(valueString) {
                    height = valueInt
                    
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "height_m")
                }
            case "id":
                if let valueString = value as? String, let valueInt = Int(valueString) {
                    id = valueInt
                    
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "id")
                }
            case "isfamily":
                if let value = value as? Int , value == 0 {
                    isFamily = false
                } else if let value = value as? Int , value == 1 {
                    isFamily = true
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "isfamily")
                }
            case "isfriend":
                if let value = value as? Int , value == 0 {
                    isFriend = false
                } else if let value = value as? Int , value == 1 {
                    isFriend = true
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "isfriend")
                }
            case "ispublic":
                if let value = value as? Int , value == 0 {
                    isPublic = false
                } else if let value = value as? Int , value == 1 {
                    isPublic = true
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "ispublic")
                }
            case "owner":
                if let value = value as? String {
                    owner = value
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "owner")
                }
            case "secret":
                if let value = value as? String {
                    secret = value
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "secret")
                }
            case "server":
                if let valueString = value as? String, let valueInt = Int(valueString) {
                    server = valueInt
                    
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "server")
                }
            case "title":
                if let value = value as? String {
                    title = value
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "title")
                }
            case "url_m":
                if let value = value as? String {
                    url = value
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "url_m")
                }
            case "width_m":
                if let valueString = value as? String, let valueInt = Int(valueString) {
                    width = valueInt
                } else {
                    throw FlickrPhotoAssignmentError.badInputValues(property: "width_m")
                }
            default:
                //unknown input. Should all be ints or strings
                print("Unknown input when initializing FlickrPhoto. Key: \(key), Value: \(value)")
            }
        }
        
                //all values assigned successfully
        return true
    } //end of attemptToAssignValues

    
} //end of struct FlickrPhoto
