//
//  PlaceTabBarController+Delegate.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: PlaceTabBarController+FetchedResultsControllerDelegate
extension PlaceTabBarController: NSFetchedResultsControllerDelegate {
    
    func fetchPlaceType() {
        
        // Fetch place type from data store
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Type")
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try appDelegate.stack.context.fetch(fetchRequest)
            if let results = results as? [Type] {
                if (results.count > 0) {
                    for type in results {
                        typeName = type.name!
                    }
                }
            }
        } catch {
            displayError("Could not fetch place type")
        }
    }
    
    func fetchPlaces() {
        
        // Fetch places from data store for the selected type
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            if let results = fetchedResultsController.fetchedObjects as? [Place] {
                PlaceTabBarController.placeCollection = results
            }
        } catch {
            displayError("Could not fetch places")
        }
    }
}

