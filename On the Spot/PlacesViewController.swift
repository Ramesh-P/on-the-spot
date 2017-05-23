//
//  PlacesViewController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/6/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

// MARK: PlacesViewController
class PlacesViewController: UIViewController {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var addressFontSize: CGFloat = CGFloat()
    var locationFontSize: CGFloat = CGFloat()
    var searchFontSize: CGFloat = CGFloat()
    var formattedAddress: String = String()
    let locationManager: CLLocationManager = CLLocationManager()
    var latitude: Double = Double()
    var longitude: Double = Double()
    var searchController: UISearchController = UISearchController()
    var isFiltered: Bool = Bool()
    var filteredPlaces: [String] = [String]()
    //var refreshControl: UIRefreshControl = UIRefreshControl()
    var type: Type?
    var place: Place?
    
    // MARK: Outlets
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var places: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Actions
    @IBAction func setting(_ sender: UIBarButtonItem) {
        
        // Present settings view
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "SettingNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func places(_ sender: UIBarButtonItem) {
        
        // Dismiss keyboard
        searchBar.resignFirstResponder()
        
        // Show saved places
        let placeType = ""
        self.performSegue(withIdentifier: "toPlaceTabBarController", sender: placeType)
    }
    
    @IBAction func unwindToPlacesViewController(segue: UIStoryboardSegue) {
        
    }

    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        locationManager.delegate = self
        searchBar.delegate = self
        isFiltered = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Initialize
        searchBarCancelButtonClicked(searchBar)
        
        // Layout
        getFontSize()
        setFontStyle()
        setPlaceholderText()
        setPlaceholderImage()
        setCancelButtonAppearance()
        setCellSize()
        places.reloadData()
        
        // Get authorization to track user location
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Stop observing
        locationManager.stopUpdatingLocation()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Show places
        if (segue.identifier == "toPlaceTabBarController") {
            let controller = segue.destination as! PlaceTabBarController
            let placeType = sender as! String
            controller.placeType = placeType
        }
    }
}

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

