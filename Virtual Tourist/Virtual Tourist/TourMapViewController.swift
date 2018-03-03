//
//  TourMapViewController.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/02/04.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class TourMapViewController: CoreDataMapViewController, UIGestureRecognizerDelegate {
    
    
   
    //MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    var models = [Pin]() //the model is an array of pins
    var appDelegate: AppDelegate!
    
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegates
        mapView.delegate = self
        
        //link the CoreDataMapViewController with the IBOutlet
        coreMapView = mapView
        
                let gestureRecognizer = VTLongPressGR(target: self, action: #selector(handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        setupFetchedResultsController()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        plotInitialPins()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncViewWithModel()
        dataCheck()
    }
    
    
    //MARK: - Map Delegate
    
    func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            
            pinView!.pinTintColor = UIColor.blue
            pinView!.animatesDrop = true
            
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            //TODO: segue to collection
            let photoTour = storyboard?.instantiateViewController(withIdentifier: "PhotoTourViewController") as! PhotoTourViewController
            let pin = view.annotation as! Pin
            photoTour.pin = pin
                        
            self.navigationController?.pushViewController(photoTour, animated: true)
           
        }
    }
    
    
    //MARK: - Model Operations
    
    func syncViewWithModel() {
        
    }
    
    func setupFetchedResultsController(){
        
        //set up stack and fetchrequest
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false),NSSortDescriptor(key: "title", ascending: true)]
        
        // So far we have a search that will match ALL Pins.
        
        // Create the FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController = fc
        
    }
    
    func dataCheck(){
        let Pins = fetchedResultsController!.fetchedObjects
        print("There are \(Pins!.count) Pins in the data model")
    }
    
    func fetchModelPins() -> [Pin] {
        return fetchedResultsController!.fetchedObjects as! [Pin]
    }
    
    func plotInitialPins() {
        mapView.addAnnotations(fetchModelPins())
    }
    
    /******************************************************/
    /******************* Navigation **************/
    /******************************************************/
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier! == "PhotoTourViewController" {
            
            if let vtVC = segue.destination as? PhotoTourViewController {
                
                //TODO: see if I need to use this
            }
        }
    }
    
        //MARK: - GestureHandlerDelegate
    
        func handleTap(gestureRecognizer: VTLongPressGR) {
        
                if (gestureRecognizer.state == UIGestureRecognizerState.began){
        
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            
            //TODO: Store the pin to the model
            let newPin = Pin(title: "Untitled", latitude: coordinate.latitude, longitude: coordinate.longitude, subtitle: nil, context: fetchedResultsController!.managedObjectContext)
            print("Just created a new Pin: \(newPin)")
            
            let defaultName = "Untitled Location"
            
            let Geocoder = CLGeocoder()
            Geocoder.reverseGeocodeLocation(CLLocation(latitude: newPin.latitude, longitude: newPin.longitude)) { (placemarks, error) in
                
                if let placemarks = placemarks {
                    print("Got the following placemarks")
                    for placemark in placemarks {
                        print(placemark.name)
                    }
                    if let name =  placemarks[0].name {
                        newPin.title = name
                    } else {
                        newPin.title = defaultName
                    }
                    
                } else {
                    //didn't get any placemarks
                    print("Error obtaining Placemark")
                    print(error)
                    
                    newPin.title = defaultName
                }
                
                self.mapView.addAnnotation(newPin)
                
                
                GCDBlackBox.performUIUpdatesOnMain {
                    self.mapView.selectAnnotation(newPin, animated: true)
                }
            }
            
            
        }
    }
    
}
