//
//  Type+CoreDataClass.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/6/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import CoreData

// MARK: Type
public class Type: NSManagedObject {
    
    // MARK: Initializers
    convenience init(name: String, context: NSManagedObjectContext) {
        
        // Create entity description for Type
        if let entity = NSEntityDescription.entity(forEntityName: "Type", in: context) {
            self.init(entity: entity, insertInto: context)
            
            self.name = name
        } else {
            fatalError("Unable to find Type entity")
        }
    }
}

