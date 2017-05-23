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

