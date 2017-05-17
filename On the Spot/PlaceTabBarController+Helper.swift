//
//  PlaceTabBarController+Helper.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/16/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: PlaceTabBarController+Helper
extension PlaceTabBarController {
    
    // MARK: Class Functions
    func getFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            titleFontSize = Constants.FontSize.Title.phoneSE
        case Constants.ScreenHeight.phone:
            titleFontSize = Constants.FontSize.Title.phone
        case Constants.ScreenHeight.phonePlus:
            titleFontSize = Constants.FontSize.Title.phonePlus
        default:
            break
        }
    }
    
    func displayTitle() {
        
        // Set title to selected place type
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Roboto-Medium", size: titleFontSize)!]
        self.title = typeName
    }
    
    func displayError(_ message: String?) {
        
        // Display Error
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

