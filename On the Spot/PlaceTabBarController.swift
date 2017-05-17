//
//  PlaceTabBarController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: PlaceTabBarController
class PlaceTabBarController: UITabBarController {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var placeType: String = String()
    var typeName: String = String()
    static var placeCollection = [Place]()
    var titleFontSize: CGFloat = CGFloat()
    //static var deleteButton: UIBarButtonItem = UIBarButtonItem()
    
    // MARK: Outlets
    @IBOutlet var delete: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func deletePlaces(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        fetchPlaceType()
        fetchPlaces()
        getFontSize()
        displayTitle()
        //PlaceTabBarController.deleteButton = delete
        
        // Center align tab bar icons
        let tabBarItems = tabBar.items! as [UITabBarItem]
        
        for tabBarItem in tabBarItems {
            tabBarItem.imageInsets = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Disable map view when place type value is empty
        let tabBarItems = tabBar.items! as [UITabBarItem]
        
        if (placeType.isEmpty) {
            let tabBarItem = tabBarItems[0] as UITabBarItem
            tabBarItem.isEnabled = false
            self.selectedIndex = 1
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

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

