//
//  Place+CoreDataClass.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/6/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import CoreData

// MARK: Place
public class Place: NSManagedObject {
    
    // MARK: Initializers
    convenience init(name: String, address: String, isOpen: Bool, rating: Double, context: NSManagedObjectContext) {
        
        // Create entity description for Place
        if let entity = NSEntityDescription.entity(forEntityName: "Place", in: context) {
            self.init(entity: entity, insertInto: context)
            
            self.name = name
            self.address = address
            self.isOpen = isOpen
            self.rating = rating
        } else {
            fatalError("Unable to find Place entity")
        }
    }
}

