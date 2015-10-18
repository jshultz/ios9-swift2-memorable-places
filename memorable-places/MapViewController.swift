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
    
    @IBOutlet weak var map: MKMapView!
    
    
    @IBAction func refreshLocation(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if activePlace == -1 {
            
        } else {
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["lon"]!).doubleValue
            let latDelta:CLLocationDegrees = 0.01 // must use type CLLocationDegrees
            let lonDelta:CLLocationDegrees = 0.01 // must use type CLLocationDegrees
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta) // Combination of two Delta Degrees
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude) // Combination of the latitude and longitude variables
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span) // takes span and location and uses those to set the region.
            self.map.setRegion(region, animated: false) // Take all that stuff and make a map!
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = places[activePlace]["name"]
            annotation.subtitle = "If you were here you would know it."
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
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            // Setup Connection
            
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let context: NSManagedObjectContext = appDel.managedObjectContext
            
            let request = NSFetchRequest(entityName: "Places")
            
            request.returnsObjectsAsFaults = false
            
            // Bleh
            
            print("Gesture Recognized")

            var title = ""
            
            let touchPoint = gestureRecognizer.locationInView(self.map)
            
            let newCoordinate: CLLocationCoordinate2D = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                if (error == nil) {
                    if let p = placemarks?[0] {
                        var subThoroughfare = ""
                        var thoroughfare = ""
                        
                        print("name: ", p.name)
                        print("p.subThoroughfare: ", p.subThoroughfare)
                        print("p.thoroughfare", p.thoroughfare)
                        
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare!
                        }
                        
                        if (p.name != "") {
                            title = String(p.name!)
                        } else {
                            title = "\(subThoroughfare) \(thoroughfare)"
                        }
                        
                        
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
                
                places.append(["name":title,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                
                do {
                    let results = try context.executeFetchRequest(request) // did we get something?
                    
                    let count:Int = results.count == 0 ? results.count : results.count + 1
                    
                    let newPlace = NSEntityDescription.insertNewObjectForEntityForName("Places", inManagedObjectContext: context)
                    
                    newPlace.setValue(Int(count), forKey: "id")
                    newPlace.setValue(String(title), forKey: "title")
                    newPlace.setValue(String(newCoordinate.latitude), forKey: "lat")
                    newPlace.setValue(String(newCoordinate.longitude), forKey: "lon")
                    
                    do {
                        try context.save()
                    } catch {
                        print("something went wrong")
                    }

                } catch {
                    print("something went wrong")
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

