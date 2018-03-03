//
//  CustomVirtualTouristCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/02/04.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//
import Foundation
import UIKit

class CustomVirtualTouristCollectionViewCell: UICollectionViewCell {
    
    //image
    @IBOutlet weak var imageView: UIImageView?
    
    //FlickrPhoto object
    var flickrPhoto: FlickrPhoto? {
        didSet {
            //try to set the label
            if let title = flickrPhoto?.title {
                self.label.text = title
            }
            
          
            if let imageData = flickrPhoto?.imageData {
                self.imageView?.image = UIImage(data:imageData as Data,scale:1.0)
            } else {
                self.imageView?.image = nil
            }
            
        }
    }
    
    //label for updates
    @IBOutlet weak var label: UILabel!
    
    /** Spinning wheel to show user that network activity is in progress */
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
   
   
    func startActivityIndicator() {
        self.activityIndicator!.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator!.stopAnimating()
    }
    
}
