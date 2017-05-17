//
//  PlacesViewController+Helper.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/16/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

// MARK: PlacesViewController+Helper
extension PlacesViewController {
    
    // MARK: Class Functions
    func getGeoLocation() {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Guard if no location was returned
            guard (error == nil) else {
                // TO DO: display error
                return
            }
            
            // Get location address
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let addressDictionary = placemark?.addressDictionary
                let addressArray = (addressDictionary?["FormattedAddressLines"] as? [String])!
                
                // Display address
                self.formattedAddress = addressArray.joined(separator: ", ")
                self.address.text = (self.formattedAddress != "") ? self.formattedAddress : "Unknown Location"
                
                // Display location
                self.location.text = "Location: " + String(format: "%.6f", self.latitude) + ", " + String(format: "%.6f", self.longitude)
                
                // Set style
                self.setFontStyle()
            }
        })
    }
    
    // MARK: Class Helpers
    func getFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            addressFontSize = Constants.FontSize.Places.Large.phoneSE
            locationFontSize = Constants.FontSize.Places.Medium.phoneSE
            searchFontSize = Constants.FontSize.Places.Large.phoneSE
        case Constants.ScreenHeight.phone:
            addressFontSize = Constants.FontSize.Places.Large.phone
            locationFontSize = Constants.FontSize.Places.Medium.phone
            searchFontSize = Constants.FontSize.Places.Large.phone
        case Constants.ScreenHeight.phonePlus:
            addressFontSize = Constants.FontSize.Places.Large.phonePlus
            locationFontSize = Constants.FontSize.Places.Medium.phonePlus
            searchFontSize = Constants.FontSize.Places.Large.phonePlus
        default:
            break
        }
    }
    
    func setFontStyle() {
        
        // Set font style
        address.font = UIFont(name: "Roboto-Regular", size: addressFontSize)
        
        let locationText = NSMutableAttributedString(string: location.text!, attributes: [NSFontAttributeName: UIFont(name: "Roboto-Regular", size: locationFontSize)!])
        locationText.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0), range: NSRange(location:0,length:9))
        location.attributedText = locationText
    }
    
    func setPlaceholderText() {
        
        // Set placeholder text
        let attributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0), NSFontAttributeName: UIFont(name: "Roboto-Regular", size: searchFontSize)!]
        let placeholderText: NSAttributedString = NSAttributedString(string: "Search", attributes: attributes)
        
        let searchField = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchField.attributedPlaceholder = placeholderText
    }
    
    func setPlaceholderImage() {
        
        // Set placeholder image
        let searchField = UISearchBar.appearance()
        searchField.setImage(UIImage(named: "Search"), for: UISearchBarIcon.search, state: UIControlState.normal)
    }
    
    func setCancelButtonAppearance() {
        
        // Set cancel button appearance
        let cancelButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Roboto-Regular", size: searchFontSize)!], for: .normal)
        cancelButton.tintColor = UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0)
    }
    
    func setCellSize() {
        
        // Layout cells for places
        let itemsPerRow: CGFloat = 4.0
        let width = UIScreen.main.bounds.size.width / itemsPerRow
        let height = width * 1.33
        
        let flowLayout = places.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: width, height: height)
    }
    
    func displayError(_ message: String?) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Display Error
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

