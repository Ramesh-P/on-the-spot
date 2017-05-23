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
import MapKit

// MARK: PlaceMapViewController
class PlaceMapViewController: UIViewController {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager: CLLocationManager = CLLocationManager()
    var locationMarker: GMSMarker = GMSMarker()
    var latitude: Double = Double()
    var longitude: Double = Double()
    var bearing: Double = Double()
    var zoom: Float = Float()
    var angle: Double = Double()
    var searchNearby: Bool = Bool()
    var radius: CLLocationDistance = CLLocationDistance()
    var latitudinalDistance: CLLocationDistance = CLLocationDistance()
    var longitudinalDistance: CLLocationDistance = CLLocationDistance()
    var circleCenter: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var zoomOnce: Bool = Bool()
    
    // MARK: Outlets
    @IBOutlet var mapView: GMSMapView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        locationManager.delegate = self
        mapView.delegate = self
        mapView.clear()
        zoomOnce = true
        
        setDefaults()
        initializeMap()
        initializeLocation()
        //initializeLocationMarker()
        showCurrentLocation()
        displaySearchRadius()
        //setCameraZoom()
        displayPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Initialize zoom
        if (zoomOnce) {
            setCameraZoom()
            zoomOnce = false
        }
        
        /*
        // Hide delete button
        PlaceTabBarController.deleteButton.image = UIImage(named: "Blank")
        PlaceTabBarController.deleteButton.isEnabled = false
 */
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

