//
//  PlaceMapViewController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

// MARK: PlaceMapViewController
class PlaceMapViewController: UIViewController {
    
    // MARK: Properties
    let locationManager: CLLocationManager = CLLocationManager()
    var latitude: Double = Double()
    var longitude: Double = Double()
    var locationMarker: GMSMarker = GMSMarker()
    var zoom: Float = Float()
    
    // MARK: Outlets
    @IBOutlet var mapView: GMSMapView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        locationManager.delegate = self
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Hide delete button
        PlaceTabBarController.deleteButton.image = UIImage(named: "Blank")
        PlaceTabBarController.deleteButton.isEnabled = false
        
        // Initialize
        initializeMap()
        initializeLocation()
        showCurrentLocation()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

// MARK: extension PlaceMapViewController
extension PlaceMapViewController {
    
    // MARK: Class Functions
    func initializeMap() {
        
        // Initialize
        mapView.animate(toBearing: 0)
        mapView.settings.scrollGestures = false
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.setMinZoom(1, maxZoom: 20)
        zoom = 15.0
    }
    
    func initializeLocation() {
        
        // Initialize
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        // Set initial location data
        var location: CLLocation = CLLocation()
        location = locationManager.location!
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    func showCurrentLocation() {
        
        // Display current location on the map
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.camera = camera
    }
}

// MARK: PlaceMapViewController: CLLocationManagerDelegate
extension PlaceMapViewController: CLLocationManagerDelegate {
    
}

// MARK: PlaceMapViewController: GMSMapViewDelegate
extension PlaceMapViewController: GMSMapViewDelegate {
    
}

