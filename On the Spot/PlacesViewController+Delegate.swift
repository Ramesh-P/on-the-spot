//
//  PlacesViewController+Delegate.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

// MARK: PlacesViewController: UISearchBarDelegate
extension PlacesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        // Reposition search bar on keyboard display
        UIView.animate(withDuration: 0.275, animations: {
            self.view.frame.origin.y = -(self.locationView.frame.size.height) + (UIApplication.shared.statusBarFrame.height) + (self.navigationController?.navigationBar.frame.height)!
        })
        
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // Display keyboard and show cancel button
        searchBar.becomeFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true)
        
        // Display places
        isFiltered = false
        places.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        // Reposition search bar on keyboard dismiss
        UIView.animate(withDuration: 0.275, animations: {
            self.view.frame.origin.y = (UIApplication.shared.statusBarFrame.height) + (self.navigationController?.navigationBar.frame.height)!
        })
        
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        // Hide cance button
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // Dismiss keyboard
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        // Display places
        isFiltered = false
        places.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Dismiss keyboard
        searchBar.text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        searchBar.resignFirstResponder()
        
        // Display places
        isFiltered = true
        places.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Search and filter places
        let searchResult = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (searchResult.isEmpty) {
            isFiltered = false
        } else {
            isFiltered = true
            filteredPlaces = Google.placeTypes.filter { $0.localizedCaseInsensitiveContains(searchResult) }
        }
        
        // Display places
        places.reloadData()
    }
}

// MARK: PlacesViewController: CLLocationManagerDelegate
extension PlacesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // Start tracking location if authorized by user
        if status == .authorizedWhenInUse {
            
            // Start observing
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Update user current location
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            getGeoLocation()
        }
    }
}

