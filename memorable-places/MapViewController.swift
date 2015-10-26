//
//  ViewController.swift
//  memorable-places
//
//  Created by Jason Shultz on 10/15/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var place: Places? = nil
    
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func refreshLocation(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
            print("place", place)
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if activePlace == -1 {
            
        } else {
            let latitude = NSString(string: (place?.lat)!).doubleValue
            let longitude = NSString(string: (place?.lon!)!).doubleValue
            let latDelta:CLLocationDegrees = 0.01 // must use type CLLocationDegrees
            let lonDelta:CLLocationDegrees = 0.01 // must use type CLLocationDegrees
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta) // Combination of two Delta Degrees
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude) // Combination of the latitude and longitude variables
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span) // takes span and location and uses those to set the region.
            self.map.setRegion(region, animated: false) // Take all that stuff and make a map!
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = place?.title
            annotation.subtitle = place?.user_description
            self.map.addAnnotation(annotation)
        }
        
        
        // Get Location
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.pausesLocationUpdatesAutomatically = true
        
        // Ending
        
        // User adds an annotation
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
        
        // Ending
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        
        print("UserLocation: ", userLocation)
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.05 // must use type CLLocationDegrees
        
        let lonDelta:CLLocationDegrees = 0.05 // must use type CLLocationDegrees
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta) // Combination of two Delta Degrees
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude) // Combination of the latitude and longitude variables
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span) // takes span and location and uses those to set the region.
        
        map.setRegion(region, animated: false) // Take all that stuff and make a map!
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func action(gestureRecognizer:UIGestureRecognizer){
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            // Setup Connection
            
            // Bleh
            
            print("Gesture Recognized")

            var title = ""
            var subThoroughfare:String = ""
            var thoroughfare:String = ""
            var street:String = ""
            var locality:String = ""
            var region:String = ""
            var country:String = ""
            var administrativeArea:String = ""
            
            let touchPoint = gestureRecognizer.locationInView(self.map)
            
            let newCoordinate: CLLocationCoordinate2D = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                if (error == nil) {
                    if let p = placemarks?[0] {
                        
                        
                        print("name: ", p.name)
                        print("p.subThoroughfare: ", p.subThoroughfare)
                        print("p.thoroughfare", p.thoroughfare)
                        
                        if p.subThoroughfare != nil {
                            subThoroughfare = String(p.subThoroughfare!)
                        } else {
                            subThoroughfare = ""
                        }
                        
                        if p.thoroughfare != nil {
                            thoroughfare = String(p.thoroughfare!)
                        } else {
                            thoroughfare = ""
                        }
                        
                        if p.locality != nil {
                            locality = String(p.locality!)
                        } else {
                            locality = ""
                        }
                        
                        if p.region != nil {
                            region = String(p.region!)
                        } else {
                            region = ""
                        }
                        
                        if p.country != nil {
                            country = String(p.country!)
                        } else {
                            country = ""
                        }
                        
                        if p.administrativeArea != nil {
                            administrativeArea = String(p.administrativeArea!)
                        } else {
                            administrativeArea = ""
                        }
                        
                        if (p.name != "") {
                            title = String(p.name!)
                        } else {
                            title = "\(subThoroughfare) \(thoroughfare)"
                            
                        }
                        
                        street = "\(subThoroughfare) \(thoroughfare)"
                        
                        
                    }
                }
                
                if title == " " {
                    title = "Added \(NSDate())"
                }
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = title
                
                annotation.subtitle = "If you were here you would know it."
                
                self.map.addAnnotation(annotation)
                
                do {
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                    
                    let entityDescripition = NSEntityDescription.entityForName("Places", inManagedObjectContext: managedObjectContext)
                    let place = Places(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
                    
                    place.setValue(String(title), forKey: "title")
                    place.setValue(String(street), forKey: "street")
                    place.setValue(String(locality), forKey: "locality")
                    place.setValue(String(region), forKey: "region")
                    place.setValue(String(country), forKey: "country")
                    place.setValue(String(newCoordinate.latitude), forKey: "lat")
                    place.setValue(String(newCoordinate.longitude), forKey: "lon")
                    place.setValue(String(administrativeArea), forKey: "administrativeArea")
                    
                    do {
                        print("place", place)
                        try managedObjectContext.save()
                    } catch {
                        print("something went wrong")
                    }

                }
                
            })
            
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("i am here")
        if segue.identifier == "newPlace" {
            print("in this spot")
            activePlace = -1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

