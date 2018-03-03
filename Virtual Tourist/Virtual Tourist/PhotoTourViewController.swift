//
//  PhotoTourViewController.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/02/04.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoTourViewController: CoreDataCollectionViewController, MKMapViewDelegate, UICollectionViewDataSource {
    
    //veiws
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var IBCollectionView: UICollectionView!

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //text field
    @IBOutlet weak var tourTitleTextField: UITextField!
    let textFieldDelegate = PhotoTourTextFieldDelegate()
    
    @IBOutlet weak var noPhotosLabel: UILabel!
    
    ///Number of photos to show in the collection view
    let numberPhotosToDisplay = 15
    
    //buttons
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var deletePhotosButton: UIButton!
    

    var pin: Pin?
    
   
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegates
        mapView.delegate = self
        self.tourTitleTextField.delegate = textFieldDelegate
        
        //set collection view
        collectionView = IBCollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //collection view selection
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        setupFetchedResultsController()
        
        plotAndZoomPin()
        
        //flickrTest()
        
        setupCollectionView()
        
        buttonStateCheckAndSet()
        
        loadText()
        
        setNoPhotosLabelVisible(isVisible: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
    }
    
    
    func loadText() {
        let titlePrimer = "Photos near "
        if let name = pin?.title {
            tourTitleTextField.text = titlePrimer + name + ":"
        } else {
            tourTitleTextField.text = titlePrimer + "Untitled Location:"
        }
    }
    
  
    //MARK: - Actions
    
    ///called when the collection button is pressed
    @IBAction func newCollectionButtonPressed(_ sender: AnyObject) {
        //clear the model
        if let context = fetchedResultsController?.managedObjectContext {
            for photo in photosToDisplay {
                context.delete(photo)
                
                print("There are \(photosToDisplay.count) objects remaining")
            }
            
            //photosToDisplay.removeAll()
            self.collectionView.reloadData()
        }
        
        
        
        print("Pre Batch: There are \(photosToDisplay.count) objects remaining")
        //request another batch
        flickrGetPhotosNearPin(radius: 5.0, tryAgain: true)
        
        //self.collectionView.reloadData()
        
    }
    
    @IBAction func deletePhotosButtonPressed(_ sender: AnyObject) {
        
        if let context = fetchedResultsController?.managedObjectContext {
            for indexPath in collectionView.indexPathsForSelectedItems! {
                //deselect this item
                collectionView.deselectItem(at: indexPath, animated: false)
                
                let photo = self.photosToDisplay[indexPath.row] as FlickrPhoto
                
                context.delete(photo)
                
                print("Just removed a photo. There are \(photosToDisplay.count) photos remaining.")
                
                
            }
            
            //reload
            self.collectionView.reloadData()
            
            
            self.collectionView.layoutIfNeeded()
            
            //make each cell fully alpha so that it does not appear to be selected
            for cell in collectionView.visibleCells as! [CustomVirtualTouristCollectionViewCell]   {
                
                cell.imageView!.alpha = 1
                cell.activityIndicator.alpha = 1
                
            }
        }
        
        buttonStateCheckAndSet()
    
    }
    
    func buttonStateCheckAndSet() {
        //if there are selected items, ensure the "Get new set of photos" button is enabled and the other is false
        
        if collectionView.indexPathsForSelectedItems!.isEmpty {
            setNewCollectionButtonState(state: true)
            setDeletePhotosButtonState(state: false)
        } else {
            setNewCollectionButtonState(state: false)
            setDeletePhotosButtonState(state: true)
        }
    }
    
    func setDeletePhotosButtonState(state: Bool) {
        deletePhotosButton.isEnabled = state
        if state {
            deletePhotosButton.alpha = 1
        } else {
            deletePhotosButton.alpha = 0
        }
    }
    
    func setNewCollectionButtonState(state: Bool) {
        newCollectionButton.isEnabled = state
        if state {
            newCollectionButton.alpha = 1
        } else {
            newCollectionButton.alpha = 0
        }
    }
    
    func setNoPhotosLabelVisible(isVisible: Bool) {
        if isVisible {
            noPhotosLabel.alpha = 1
            noPhotosLabel.isEnabled = true
        } else {
            noPhotosLabel.alpha = 0
            noPhotosLabel.isEnabled = false
        }
    }
    
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("There are ", String(self.photosToDisplay.count), " photos to display")
        return self.photosToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //print("From cellForItemAtIndexPath.  There are ", String(self.sharedMemes.count), " shared Memes")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrPhotoCollectionCell", for: indexPath as IndexPath) as! CustomVirtualTouristCollectionViewCell
        let photo = self.photosToDisplay[indexPath.row]
        
        //associate the photo with this cell, which will set all parts of image view
        cell.flickrPhoto = photo
        
        if photo.isTransitioningImage {
            cell.startActivityIndicator()
        } else {
            cell.stopActivityIndicator()
        }
        
        return cell
    }
    
    //When a user selects an item from the collection
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //TODO: What to do when a photo is selected
        print("about to show detail from the collection view for meme at indexPath: ",indexPath.row)
        print("A photo was selected. Here are all the index paths: \(collectionView.indexPathsForSelectedItems)")
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomVirtualTouristCollectionViewCell {
            cell.imageView!.alpha = 0.5
            cell.activityIndicator.alpha = 0
        }
        
        buttonStateCheckAndSet()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomVirtualTouristCollectionViewCell {
            cell.imageView!.alpha = 1
            cell.activityIndicator.alpha = 1
        }
        
        buttonStateCheckAndSet()
    }
   
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let space: CGFloat!
        let dimension: CGFloat!
        
     
        if UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) { //If portrait mode
            //implement flow layout
            space = 1.0
            // have 2 items across if in portrait
            let numberOfItems: CGFloat = 3
            let spacingConstant: CGFloat = numberOfItems - 1
            dimension = (self.view.frame.size.width - (2 * space) - (spacingConstant * space)) / numberOfItems
        } else { //if not in portrait mode
            //implement flow layout
            space = 1.0
            // have 2 items across if in not portrait
            let numberOfItems: CGFloat = 2
            let spacingConstant: CGFloat = numberOfItems - 1
            dimension = (self.view.frame.size.width - (2 * space) - (spacingConstant * space)) / numberOfItems
        }
        //set the flowLayout based on new values
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    
    
    //MARK: - Flickr API
    
    func flickrGetPhotosNearPin(radius: Double, tryAgain: Bool = false){
        setNoPhotosLabelVisible(isVisible: false)
        
        if let pin = pin {
            GCDBlackBox.runNetworkFunctionInBackground {
                FlickrClient.sharedInstance.getFlickrSearchNearLatLong(pin.latitude, long: pin.longitude, radius: radius) { (results, error) in
                    GCDBlackBox.performUIUpdatesOnMain {
                        if let flickrPhotos = results as? FlickrPhotoResults {
                            print("Successful getFlickrSearchNearLatLong.  Results: \(flickrPhotos)")
                            //results are a FlickrPhotoResults array of FlickrPhotoResult objects
                            
                            if !(flickrPhotos.photos.isEmpty) {
                                //there is at least 1 photo returned
                                
                                //get a shuffled array of the images
                                let shuffledFlickrPhotosArray = flickrPhotos.photos.shuffled()
                                
                                //take the first x number of photos
                                for index in 0...(self.numberPhotosToDisplay-1) {
                                    //only do this if the index falls within the length of the array
                                    if index < shuffledFlickrPhotosArray.count {
                                    
                                        //create FlickrPhoto objects
                                        let newFlickrPhoto = FlickrPhoto(FlickrResult: shuffledFlickrPhotosArray[index], context: self.fetchedResultsController!.managedObjectContext)
                                        
                                        //set the associated pin
                                        newFlickrPhoto.pin = self.pin
                                        print("Just created a new FlickrPhoto: \(newFlickrPhoto.id)")
                                        
                                        //fetch photo data
                                        newFlickrPhoto.checkAndDownloadImage()
                                        
                                    
                                    }
                                }
                                
                            } else {
                                //there were no photos returned
                                //TODO: Handle case where no photos returned
                                print("There were no photos returned: \(flickrPhotos.photos)")
                                
                                //if we should try again if we get no photos
                                
                                if tryAgain {
                                    //try again at 4x the radius
                                    print("Trying to get photos again at 4x radius: \(radius)")
                                    self.flickrGetPhotosNearPin(radius: radius*4, tryAgain: false)
                                
                                } else {
                                //we will not try again, so tell the user
                                    self.setNoPhotosLabelVisible(isVisible: true)
                                    
                                }
                                
                            } //end checking for 0 photos
                            
                        } else {
                            //TODO: handle case where looking for photos resulted in a parsing error
                            print("Error with getFlickrSearchNearLatLong.  Error: \(error)")
                        }
                    }// end performingUIUpdatesOnMain
                }
            }//end GCDBlackBox.runNetworkFunctionInBackground
        }
    }
    
   
    //MARK: - Model Operations
    
    func setupFetchedResultsController(){
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrPhoto")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false),NSSortDescriptor(key: "id", ascending: true)]
        
        // So far we have a search that will match ALL notes. However, we're
        // only interested in those within the current notebook:
        // NSPredicate to the rescue!
        
        let pred = NSPredicate(format: "pin = %@", argumentArray: [self.pin!])
        
        fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController = fc
        
    }
    
    func fetchModelFlickrPhotos() -> [FlickrPhoto] {
        return fetchedResultsController!.fetchedObjects as! [FlickrPhoto]
    }
    
    func setupCollectionView() {
        //TODO: Clear the contents of the collection view first?
        
        //if there are stored FlickrPhotos in the model, load them into the collection view
        photosToDisplay = fetchModelFlickrPhotos()
        
        //if the contents is empty, the load some contents
        if photosToDisplay.count < 1 {
            flickrGetPhotosNearPin(radius: 5.0, tryAgain: true)
        }
            
        
    }

    //MARK: - Map Functions
    
    
    func plotAndZoomPin(){
        if let pin = pin {
            plotPin()
            
            mapView.showAnnotations([pin], animated: true)
            
        }
    }
    
    func plotPin(){
        if let pin = pin {
            mapView.addAnnotation(pin)
        }
    }
    
        //MARK: - Map Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            
            pinView!.pinTintColor = UIColor.red
            pinView!.animatesDrop = true
            
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    /******************************************************/
    /******************* testing **************/
    /******************************************************/
    //MARK: - testing
    
    func flickrTest() {
        
        let parameters = [
            FlickrClient.Constants.ParameterKeys.Method: FlickrClient.Constants.Methods.SearchPhotos,
            FlickrClient.Constants.ParameterKeys.Format: FlickrClient.Constants.ParameterValues.ResponseFormat,
            FlickrClient.Constants.ParameterKeys.NoJSONCallback: FlickrClient.Constants.ParameterValues.DisableJSONCallback
        ]
        FlickrClient.sharedInstance.taskForGETMethod(parameters: parameters as [String : AnyObject]) { (result, error) in
            if result != nil {
                print("Successful Flickr Test.  Results: \(result)")
            } else {
                print("Error with Flickr Test.  Error: \(error)")
            }
        }
    }
}
