//
//  PlacesViewController+CoreData.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/16/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

// MARK: PlacesViewController+CoreData
extension PlacesViewController {
    
    func dropAllData(completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        // Delete all stored data from core data store
        do {
            try self.appDelegate.stack.dropAllData()
        } catch {
            completion(false, "Error deleting saved results")
        }
        
        completion(true, nil)
    }
    
    func saveType(placeType name: String, completion: @escaping (_ result: Type?) -> Void) {
        
        // Save type detail to data store
        type = Type(name: name, context: appDelegate.stack.context)
        appDelegate.stack.saveContext()
        
        completion(type)
    }
    
    func savePlace(_ type: Type, completion: @escaping (_ result: Type?) -> Void) {
        
        // Save places for selected type into the data store
        let places = appDelegate.googlePlaces
        
        for item in places {
            place = Place(name: item.name, address: item.address, isOpen: item.isOpen, rating: item.rating, context: appDelegate.stack.context)
            place?.type = type
            appDelegate.stack.saveContext()
        }
        
        completion(type)
    }
}

