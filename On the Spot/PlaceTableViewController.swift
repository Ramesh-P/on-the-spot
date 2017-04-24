//
//  PlaceTableViewController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: PlaceTableViewController
class PlaceTableViewController: UIViewController {
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Show delete button
        PlaceTabBarController.deleteButton.image = UIImage(named: "Delete")
        PlaceTabBarController.deleteButton.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

