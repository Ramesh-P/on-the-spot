//
//  PlaceTableViewController+Helper.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/17/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: PlaceTableViewController+Helper
extension PlaceTableViewController {
    
    // MARK: Class Functions
    func getFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            nameFontSize = Constants.FontSize.PlaceTable.Large.phoneSE
            addressFontSize = Constants.FontSize.PlaceTable.Medium.phoneSE
            ratingFontSize = Constants.FontSize.PlaceTable.Small.phoneSE
            statusFontSize = Constants.FontSize.PlaceTable.Small.phoneSE
        case Constants.ScreenHeight.phone:
            nameFontSize = Constants.FontSize.PlaceTable.Large.phone
            addressFontSize = Constants.FontSize.PlaceTable.Medium.phone
            ratingFontSize = Constants.FontSize.PlaceTable.Small.phone
            statusFontSize = Constants.FontSize.PlaceTable.Small.phone
        case Constants.ScreenHeight.phonePlus:
            nameFontSize = Constants.FontSize.PlaceTable.Large.phonePlus
            addressFontSize = Constants.FontSize.PlaceTable.Medium.phonePlus
            ratingFontSize = Constants.FontSize.PlaceTable.Small.phonePlus
            statusFontSize = Constants.FontSize.PlaceTable.Small.phonePlus
        default:
            break
        }
    }
}

