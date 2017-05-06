//
//  Place+CoreDataProperties.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/6/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var isOpen: Bool
    @NSManaged public var rating: Double
    @NSManaged public var type: Type?

}
