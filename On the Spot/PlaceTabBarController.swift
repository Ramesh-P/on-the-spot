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
    var titleFontSize: CGFloat = CGFloat()
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
        getFontSize()
        displayTitle()
        
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
        
        if (PlaceTabBarController.placeType.isEmpty) {
            let tabBarItem = tabBarItems[0] as UITabBarItem
            tabBarItem.isEnabled = false
            self.selectedIndex = 1
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

// MARK: extension PlaceTabBarController
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
        
        if (PlaceTabBarController.placeType.isEmpty) {
            self.title = "Saved Places"
            
        } else {
            self.title = PlaceTabBarController.placeType
        }
    }
}

