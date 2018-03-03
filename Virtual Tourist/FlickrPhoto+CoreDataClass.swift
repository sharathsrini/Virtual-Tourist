//
//  FlickrPhoto+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/02/04.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//

import Foundation
import CoreData


public class FlickrPhoto: NSManagedObject {
    
    var isTransitioningImage = false
    
    convenience init(FlickrResult: FlickrPhotoResult, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "FlickrPhoto", in: context) {
            self.init(entity: ent, insertInto: context)
            
            //using the FlickrPhotoResult, populate this object
            if let farm = FlickrResult.farm,
               let height = FlickrResult.height,
               let id = FlickrResult.id,
                let isFamily = FlickrResult.isFamily,
                let isFriend = FlickrResult.isFriend,
                let isPublic = FlickrResult.isPublic,
                let owner = FlickrResult.owner,
                let secret = FlickrResult.secret,
                let server = FlickrResult.server,
                let title = FlickrResult.title,
                let url = FlickrResult.url,
                let width = FlickrResult.width {
                
                self.farm = Int64(farm)
                self.height = Int64(height)
                self.id = Int64(id)
                self.isFamily = isFamily
                self.isFriend = isFriend
                self.isPublic = isPublic
                self.owner = owner
                self.secret = secret
                self.server = Int64(server)
                self.title = title
                self.url = url
                self.width = Int64(width)
                
            } else {
                //TODO: throw an error because everything wasn't as expected
            }
        } else {
            fatalError("Unable to find Entity name! (FlickrPhoto)")
        }

    }
    

    
    func checkAndDownloadImage() {
        if self.imageData == nil {
            flickrDownloadImageData()
        }
    }
    

    
    func flickrDownloadImageData() {
        //download image data based on the URL
        
        //TODO: start activity spinner
        isTransitioningImage = true
        GCDBlackBox.runNetworkFunctionInBackground {
            let _ = FlickrClient.sharedInstance.taskForGETImage(filePath: self.url) {
                (imageData, error) in
                GCDBlackBox.performUIUpdatesOnMain {
                    if let imageDataNS = imageData as NSData? {
                        
                        self.imageData = imageDataNS
                        print("Image data succesfully retireved and set")
                        
                    } else {
                        //there was an error
                        //TODO: handle error
                    }
                    
                    //TODO: stop activity spinner
                    self.isTransitioningImage = false
                }//endUI updates on main
            }
        }//end background black box
    }
    
}
