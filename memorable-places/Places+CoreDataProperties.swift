//
//  Places+CoreDataProperties.swift
//  memorable-places
//
//  Created by Jason Shultz on 10/22/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Places {

    @NSManaged var administrativeArea: String?
    @NSManaged var country: String?
    @NSManaged var id: NSNumber?
    @NSManaged var lat: String?
    @NSManaged var locality: String?
    @NSManaged var lon: String?
    @NSManaged var region: String?
    @NSManaged var street: String?
    @NSManaged var title: String?
    @NSManaged var user_description: String?

}
