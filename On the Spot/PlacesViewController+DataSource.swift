//
//  PlacesViewController+DataSource.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/22/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

// MARK: PlacesViewController: UICollectionViewDataSource, UICollectionViewDelegate
extension PlacesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Set total cells
        var count: Int = Int()
        
        if (isFiltered) {
            count = filteredPlaces.count
        } else {
            count = Google.placeTypes.count
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! Cell
        var id: String = String()
        var image: String = String()
        
        // Display places
        if (isFiltered) {
            id = String(filteredPlaces[indexPath.row].components(separatedBy: ":").first!)
        } else {
            id = String(indexPath.row)
        }
        
        image = "Place Icon-" + id
        cell.placeIcon.image = UIImage(named: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        var id: String = String()
        var image: String = String()
        
        // Display selected place
        if (isFiltered) {
            id = String(filteredPlaces[indexPath.row].components(separatedBy: ":").first!)
        } else {
            id = String(indexPath.row)
        }
        
        image = "Place Icon-" + id + " Selected"
        cell.placeIcon.image = UIImage(named: image)
        
        // Show selected places
        var placeType: String = String()
        
        if (isFiltered) {
            placeType = String(filteredPlaces[indexPath.row].components(separatedBy: ":").last!)
        } else {
            placeType = String(Google.placeTypes[indexPath.row].components(separatedBy: ":").last!)
        }
        
        let type = (placeType.replacingOccurrences(of: " ", with: "_")).lowercased()
        let location = String(latitude) + "," + String(longitude)
        
        GoogleAPIMethods.sharedInstance().fetchNearbyPlaces(of: type, for: location) { (success, error) in
            
            performUIUpdatesOnMain {
                
                // Dismiss keyboard & reset
                self.searchBar.resignFirstResponder()
                self.searchBarCancelButtonClicked(self.searchBar)
                
                if success {
                    
                    // Delete previously saved type & places from the data store
                    self.dropAllData() { (success, error) in
                        if success {
                            
                            // Save newly selected type into the data store
                            self.saveType(placeType: placeType) { (result) in
                                if (result != nil) {
                                    
                                    // Save places for selected type into the data store
                                    self.savePlace(result!) { (result) in
                                        if (result != nil) {
                                            
                                            // Display places
                                            self.performSegue(withIdentifier: "toPlaceTabBarController", sender: placeType)
                                        } else {
                                            self.displayError("Error saving search result")
                                        }
                                    }
                                } else {
                                    self.displayError("Error saving search result")
                                }
                            }
                        } else {
                            self.displayError(error)
                        }
                    }
                } else {
                    var errorMessage: String = error!
                    
                    if (errorMessage == Google.ResponseValues.zeroResults) {
                        if (self.appDelegate.searchNearby) {
                            errorMessage = "There is no " + (placeType).lowercased() + " nearby within 30 miles"
                        } else {
                            errorMessage = "There is no " + (placeType).lowercased() + " nearby. Please increase the radius and search again"
                        }
                    }
                    
                    self.displayError(errorMessage)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        // Reset unselected place
        if let cell = collectionView.cellForItem(at: indexPath) as? Cell {
            var id: String = String()
            var image: String = String()
            
            // Display selected place
            if (isFiltered) {
                id = String(filteredPlaces[indexPath.row].components(separatedBy: ":").first!)
            } else {
                id = String(indexPath.row)
            }
            
            image = "Place Icon-" + id
            cell.placeIcon.image = UIImage(named: image)
        }
    }
}

