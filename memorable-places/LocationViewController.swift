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
    
    var place: Places? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    //-- fetch data from CoreData --//
    func fetchPapers () {
        if place != nil {
            titleLabel.text = place?.title
            descriptionLabel.text = place?.user_description
            streetLabel.text = place?.street
            cityLabel.text = place?.locality
            stateLabel.text = place?.administrativeArea
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchPapers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "mapSegue" {
            let mapController:MapViewController = segue.destinationViewController as! MapViewController
            mapController.place = place
        } else if segue.identifier == "editPlace" {
            let editController:EditLocationViewController = segue.destinationViewController as! EditLocationViewController
            editController.place = place
        }
    }


}
