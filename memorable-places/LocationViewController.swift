//
//  LocationViewController.swift
//  memorable-places
//
//  Created by Jason Shultz on 10/18/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import CoreData

class LocationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Places")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if (results.count > 0) {
                
                for result in results as! [NSManagedObject] {
                    if let title:String = result.valueForKey("title") as? String {
                        titleLabel.text = String(UTF8String: title)!
                    } else {
                        titleLabel.text = ""
                    }
                    if let street = result.valueForKey("street") as? String {
                        streetLabel.text = String(street)
                    } else {
                        streetLabel.text = ""
                    }
                    if let locality = result.valueForKey("locality") as? String {
                        cityLabel.text = String(locality)
                    } else {
                        cityLabel.text = ""
                    }
                    if let description = result.valueForKey("user_description") as? String {
                        descriptionLabel.text = String(description)
                    } else {
                        descriptionLabel.text = ""
                    }
                    if let administrativeArea = result.valueForKey("administrativeArea") as? String {
                        stateLabel.text = String(administrativeArea)
                    } else {
                        stateLabel.text = ""
                    }
                }
                
            }
        } catch {
            print("something went wrong")
        }

        // Do any additional setup after loading the view.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
