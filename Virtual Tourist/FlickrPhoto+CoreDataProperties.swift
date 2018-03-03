//
//  FlickrPhoto+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/02/04.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//

import Foundation
import CoreData
 

extension FlickrPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlickrPhoto> {
        return NSFetchRequest<FlickrPhoto>(entityName: "FlickrPhoto");
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var farm: Int64
    @NSManaged public var height: Int64
    @NSManaged public var id: Int64
    @NSManaged public var isFamily: Bool
    @NSManaged public var isFriend: Bool
    @NSManaged public var isPublic: Bool
    @NSManaged public var owner: String
    @NSManaged public var secret: String
    @NSManaged public var server: Int64
    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var width: Int64
    @NSManaged public var pin: Pin?

}
