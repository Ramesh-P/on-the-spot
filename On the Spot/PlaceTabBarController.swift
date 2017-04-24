//
//  PlaceTabBarController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: PlaceTabBarController
class PlaceTabBarController: UITabBarController {
    
    // MARK: Properties
    static var placeType: String = String()
    static var deleteButton: UIBarButtonItem = UIBarButtonItem()
    
    // MARK: Outlets
    @IBOutlet var delete: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func deletePlaces(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        PlaceTabBarController.deleteButton = delete
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Set default startup tab
        if (PlaceTabBarController.placeType.isEmpty) {
            self.selectedIndex = 1
        } else {
            self.selectedIndex = 0
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

