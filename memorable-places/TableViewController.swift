//
//  TableViewController.swift
//  memorable-places
//
//  Created by Jason Shultz on 10/15/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import CoreData

//var places = [Dictionary<String,String>()]

var activePlace = -1

//let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//let context: NSManagedObjectContext = appDel.managedObjectContext
//
//let request = NSFetchRequest(entityName: "Places")

//var objectsAry = [NSManagedObject]()


class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: placeFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultController
    }
    
    func placeFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Places")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
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
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PlacesTableViewCell
        let place = fetchedResultController.objectAtIndexPath(indexPath) as! Places
        cell.locationNameLabel!.text = place.title
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activePlace = indexPath.row
        return indexPath
    }
    
    override func viewWillAppear(animated: Bool) {
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("something done gone wrong")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    // MARK: - TableView Deleteƒ
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    
    // MARK: - TableView Refresh
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
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
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let locationController:LocationViewController = segue.destinationViewController as! LocationViewController
            let location:Places = fetchedResultController.objectAtIndexPath(indexPath!) as! Places

            locationController.place = location
        }
    }


}
