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

