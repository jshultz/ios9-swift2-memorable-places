//
//  TableViewController.swift
//  memorable-places
//
//  Created by Jason Shultz on 10/15/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import CoreData

var places = [Dictionary<String,String>()]

var activePlace = -1

let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let context: NSManagedObjectContext = appDel.managedObjectContext

let request = NSFetchRequest(entityName: "Places")




class TableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PlacesTableViewCell
        print("id ", places[indexPath.row])
        cell.locationNameLabel!.text = places[indexPath.row]["name"]
        cell.placeIdLabel!.text = places[indexPath.row]["thisID"]
//        cell.textLabel?.text = places[indexPath.row]["name"]

        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activePlace = indexPath.row
        
        return indexPath
    }
    
    override func viewWillAppear(animated: Bool) {
        
        places.removeAll()
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if (results.count > 0) {
                
                for result in results as! [NSManagedObject] {
                    let thisID = result.objectID
                    let id:String = String(result.valueForKey("id")!)
                    let title:String = String(result.valueForKey("title")!)
                    let lat:String = String(result.valueForKey("lat")!)
                    let lon:String = String(result.valueForKey("lon")!)
                    places.append(["name":"\(title)","lat":"\(lat)","lon":"\(lon)","id":"\(id)","thisID":"\(thisID)"])
                }
            }
        } catch {
            print("something went wrong")
        }
        
        if places.count == 0 {
            places.append(["name":"Taj Mahal","lat":"27.175277","lon":"78.042128"])
            
        }
        
        
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            do {
                let results = try context.executeFetchRequest(request)
                
                let placeToDelete = results[indexPath.row]
                
                // Delete it from the managedObjectContext
                context.deleteObject(placeToDelete as! NSManagedObject)
                
                do {
                    try context.save()
                } catch {
                    print("something went wrong?")
                }
                
            
            } catch {
                print("something went wrong")
            }
            // Delete the row from the data source
            places.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation
    // This is fired on the view originating the segue, not the view receiving the segue.

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPlace" {
            print("in this spot")
            activePlace = -1
        } else {
//            activePlace = indexPath[row]
        }
    }


}
