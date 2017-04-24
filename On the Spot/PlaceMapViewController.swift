//
//  PlaceMapViewController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: PlaceMapViewController
class PlaceMapViewController: UIViewController {
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Hide delete button
        PlaceTabBarController.deleteButton.image = nil
        PlaceTabBarController.deleteButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

