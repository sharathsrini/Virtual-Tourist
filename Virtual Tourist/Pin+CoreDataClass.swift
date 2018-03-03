//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/01/24.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class Pin: NSManagedObject, MKAnnotation {

    
    convenience init(title: String = "Unknown Location", latitude: Double, longitude: Double, subtitle: String?, context: NSManagedObjectContext) {
        
             if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: ent, insertInto: context)
            self.title = title
            self.latitude = latitude
            self.longitude = longitude
            self.creationDate = Date()
            if let givenSubtitle = subtitle{
                self.subtitle = givenSubtitle
            }
        } else {
            fatalError("Unable to find Entity name! (Pin)")
        }
    }
    
       
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
