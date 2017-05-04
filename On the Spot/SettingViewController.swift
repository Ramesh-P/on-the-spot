//
//  SettingViewController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/4/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import UIKit

// MARK: SettingViewController
class SettingViewController: UIViewController {
    
    // MARK: Properties
    
    // MARK: Outlets
    
    // MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Dismiss settings view
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

