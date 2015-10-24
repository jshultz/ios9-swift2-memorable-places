//
//  EditLocationViewController.swift
//  memorable-places
//
//  Created by Jason Shultz on 10/20/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import CoreData

class EditLocationViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    var allPapers = [NSManagedObject]()
    
    var place: Places? = nil
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    
    override func viewWillAppear(animated: Bool) {
        
        fetchPapers()
        
    }
    
    //-- fetch data from CoreData --//
    func fetchPapers () {
        titleField.text = place?.title
        descriptionField.text = place?.user_description
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func submitChanges(sender: AnyObject) {
        
        place?.title = titleField.text
        place?.user_description = descriptionField.text
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textfield: UITextField) -> Bool {
        descriptionField.resignFirstResponder()
        return true
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
