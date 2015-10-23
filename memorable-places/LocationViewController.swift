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
    
    var allPapers = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    //-- fetch data from CoreData --//
    func fetchPapers () {
        
        //-- CoreData starts --//
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Places")
        
        var error: NSError?
        
        do {
            allPapers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            for paper in allPapers {
                
                let place_id:Int = (paper.valueForKey("id") as? Int)!
                
                print("activePlace ", Int(activePlace))
                print("place_id ", place_id)
            
                if place_id == Int(activePlace) {
                    titleLabel.text = paper.valueForKey("title") as? String
                    cityLabel.text = paper.valueForKey("locality") as? String
                    descriptionLabel.text = paper.valueForKey("user_description") as? String
                    stateLabel.text = paper.valueForKey("administrativeArea") as? String
                    streetLabel.text = paper.valueForKey("street") as? String
                }
            }
            
        } catch {
            print("Not fetched\(error)")
        }
        
        //-- CoreData ends --//
        
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchPapers()
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
