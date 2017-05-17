//
//  SettingViewController+Helper.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/17/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// MARK: extension SettingViewController
extension SettingViewController {
    
    // MARK: Class Functions
    
    // MARK: Class Helpers
    func getFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            titleFontSize = Constants.FontSize.Setting.Large.phoneSE
            messageFontSize = Constants.FontSize.Setting.Medium.phoneSE
            contentFontSize = Constants.FontSize.Setting.Large.phoneSE
        case Constants.ScreenHeight.phone:
            titleFontSize = Constants.FontSize.Setting.Large.phone
            messageFontSize = Constants.FontSize.Setting.Medium.phone
            contentFontSize = Constants.FontSize.Setting.Large.phone
        case Constants.ScreenHeight.phonePlus:
            titleFontSize = Constants.FontSize.Setting.Large.phonePlus
            messageFontSize = Constants.FontSize.Setting.Medium.phonePlus
            contentFontSize = Constants.FontSize.Setting.Large.phonePlus
        default:
            break
        }
    }
    
    func setFontStyle() {
        
        // Set font style
        for titleLabel in titleLabels {
            titleLabel.font = UIFont(name: "Roboto-Medium", size: titleFontSize)
        }
        
        typeSegmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Roboto-Regular", size: contentFontSize)!], for: .normal)
        typeDescription.font = UIFont(name: "Roboto-Regular", size: messageFontSize)
        
        for distanceButton in distanceButtons {
            distanceButton.titleLabel!.font =  UIFont(name: "Roboto-Regular", size: contentFontSize)
        }
        
        credit.titleLabel!.font =  UIFont(name: "Roboto-Regular", size: contentFontSize)
        help.titleLabel!.font =  UIFont(name: "Roboto-Regular", size: contentFontSize)
        legal.titleLabel!.font =  UIFont(name: "Roboto-Regular", size: contentFontSize)
    }
    
    func setButtonStyle() {
        
        // Set button style
        for distanceButton in distanceButtons {
            //distanceButton.layer.cornerRadius = 5
            distanceButton.layer.borderWidth = 1
        }
    }
    
    func setLayout() {
        
        // Initialize to saved/default values
        searchNearby = appDelegate.searchNearby
        distanceInMiles = appDelegate.distanceInMiles
        searchRadius = appDelegate.searchRadius
        
        // Set controls (back) to initial value
        resetUnselectedButton()
        
        if (searchNearby) {
            typeSegmentedControl.selectedSegmentIndex = 0
            searchDescriptionFor(typeSegmentedControl.titleForSegment(at: 0)!)
            disableButton()
        } else {
            let id = Int(distanceInMiles)
            setSelectedButton(id)
            typeSegmentedControl.selectedSegmentIndex = 1
            searchDescriptionFor(typeSegmentedControl.titleForSegment(at: 1)!)
            enableButton()
        }
    }
    
    func searchDescriptionFor(_ title: String) {
        
        // Display search type description
        if (title == "Nearby") {
            typeDescription.text = "Places are searched based on their distance to your current location and not by their ranking."
        } else if (title == "Distance") {
            typeDescription.text = "Places are searched based on their ranking and not by their distance to your current location."
        }
    }
    
    func resetUnselectedButton() {
        
        // Set unselected radius button appearance
        for distanceButton in distanceButtons {
            distanceButton.backgroundColor = UIColor.clear
            distanceButton.layer.borderColor = UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0).cgColor
            distanceButton.setTitleColor(UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0), for: .normal)
        }
    }
    
    func setSelectedButton(_ sender: Int) {
        
        // Set selected radius button appearance
        for distanceButton in distanceButtons {
            if (distanceButton.tag == sender) {
                distanceButton.backgroundColor = UIColor(red: 92.0/255, green: 226.0/255, blue: 237.0/255, alpha: 1.0)
                distanceButton.layer.borderColor = UIColor(red: 92.0/255, green: 226.0/255, blue: 237.0/255, alpha: 1.0).cgColor
                distanceButton.setTitleColor(UIColor(red: 69.0/255, green: 71.0/255, blue: 83.0/255, alpha: 1.0), for: .normal)
            }
        }
    }
    
    func enableButton() {
        
        // Enable radius buttons
        for distanceButton in distanceButtons {
            distanceButton.isEnabled = true
            distanceButton.alpha = 1.0
        }
    }
    
    func disableButton() {
        
        // Disable radius buttons
        for distanceButton in distanceButtons {
            distanceButton.isEnabled = false
            distanceButton.alpha = 0.5
        }
    }
}

