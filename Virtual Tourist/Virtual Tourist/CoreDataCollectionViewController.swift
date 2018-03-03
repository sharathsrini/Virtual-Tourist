//
//  CoreDataCollectionViewController.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/02/04.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataCollectionViewController: UIViewController, UICollectionViewDelegate {
    
        //MARK: - Properties
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
            //TODO: Reload data
            //coreMapView.reloadData()
        }
    }
    
    var fetchedTextResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedTextResultsController?.delegate = self
            executeTextSearch()
            //TODO: Reload data
            //coreMapView.reloadData()
        }
    }
    
    
    
    var collectionView: UICollectionView!
    var photosToDisplay = [FlickrPhoto]()
    
    var stack: CoreDataStack!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
    }
    
        //MARK: - UICollectionView Delegate and Data Source
    
    
    //When a user selects an item from the collection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("This stub should be implimented by a child class")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("This stub should be implimented by a child class")
    }
    
}

// MARK: - CoreDataCollectionViewController (Fetches)

extension CoreDataCollectionViewController {
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
    
    func executeTextSearch() {
        if let fc = fetchedTextResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedTextResultsController)")
            }
        }
    }
    
    
}

// MARK: - CoreDataCollectionViewController: NSFetchedResultsControllerDelegate

extension CoreDataCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let theFlickrPhoto = anObject as? FlickrPhoto {
            
            switch(type) {
            case .insert:
                //this will be done in the view controller so it can be selected
                photosToDisplay.append(theFlickrPhoto)
                
                print("case insert")
            case .delete:
                //TODO: Delete from collection view
                removeFromPhotosToDisplayByID(removeThisPhoto: theFlickrPhoto)
                print("case delete")
            case .update:
                //TODO: replace a cell in the collection view
                print("case update")
            case .move:
                //TODO: move a cell... this may not be needed
                print("case move")
            }
            
            //save
            stack.save()
          
            //TODO: Persist the text box
            
        } else
        {
            fatalError("Couldn't get a FlickrPhoto from anObject in didChange")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.endUpdates()
        print("About to reload collection view data")
        self.collectionView!.reloadData()
    }
    
    func removeFromPhotosToDisplayByID(removeThisPhoto: FlickrPhoto) {
        for photo in photosToDisplay {
            if photo.id == removeThisPhoto.id {
                photosToDisplay.removeObject(object: photo)
            }
        }
    }
}
