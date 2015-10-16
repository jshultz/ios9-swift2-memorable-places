//
//  ViewController.swift
//  memorable-places
//
//  Created by Jason Shultz on 10/15/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    
    @IBAction func refreshLocation(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
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
                        
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare!
                        }
                        
                        title = "\(subThoroughfare) \(thoroughfare)"
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
                
                print("places: ", places)
            })
            
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPlace" {
            activePlace = -1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

