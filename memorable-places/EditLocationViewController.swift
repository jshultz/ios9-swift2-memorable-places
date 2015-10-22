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
    
    
    override func viewWillAppear(animated: Bool) {
        
        fetchPapers()
        
    }
    
    //-- fetch data from CoreData --//
    func fetchPapers () {
        
        //-- CoreData starts --//
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Places")
        
        var error: NSError?
        
        do {
            allPapers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            for paper in allPapers {
                
                let place_id = paper.valueForKey("id") as? Int
                
                print("activePlace ", activePlace)
                print("place_id ", String(place_id!))
                
                if String(place_id!) == String(activePlace) {
                    titleField.text = paper.valueForKey("title") as? String
                    descriptionField.text = paper.valueForKey("user_description") as? String
                }
                
                
            }
            
        } catch {
            print("Not fetched\(error)")
        }
        
        //-- CoreData ends --//
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func submitChanges(sender: AnyObject) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Places")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if (results.count > 0) {
                let title = titleField?.text
                let user_description = descriptionField?.text
                
                for result in results as! [NSManagedObject] {
                    
                    let place_id = result.valueForKey("id") as? Int
                    
                    if String(place_id!) == String(activePlace) {
                        result.setValue(String(titleField.text!), forKey: "title")
                        result.setValue(String(descriptionField.text!), forKey: "user_description")
                    }
                    
                    
                }
                
                do {
                    print("here in the save")
                    try context.save() 
                } catch {
                    print("something went wroing")
                }
                
            }
        } catch {
            print("something went wrong")
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
