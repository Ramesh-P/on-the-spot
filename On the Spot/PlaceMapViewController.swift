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
    
    // MARK: Outlets
    @IBOutlet var mapView: GMSMapView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        locationManager.delegate = self
        mapView.delegate = self
        mapView.clear()
        
        setDefaults()
        initializeMap()
        initializeLocation()
        //initializeLocationMarker()
        
        showCurrentLocation()
        displaySearchRadius()
        setCameraZoom()
        displayPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Hide delete button
        PlaceTabBarController.deleteButton.image = UIImage(named: "Blank")
        PlaceTabBarController.deleteButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

// MARK: extension PlaceMapViewController
extension PlaceMapViewController {
    
    // MARK: Class Functions
    func setDefaults() {
        
        bearing = 0 /* 0: North, 90: East, 180: South, 270: West */
        searchNearby = appDelegate.searchNearby
        radius = appDelegate.searchRadius
        
        if (searchNearby) {
            
            // Set values for street level
            mapView.setMinZoom(10, maxZoom: 20)
            zoom = 16.25 // (15 and 17.5) /* 1: World, 5: Landmass/Continent, 10: City, 15: Streets, 20: Buildings */
            angle = 60 // (30 and 65) /* 0: Pointing straight down at the map */
            latitudinalDistance = CLLocationDistance(self.view.bounds.height)
            longitudinalDistance = CLLocationDistance(self.view.bounds.width)
        } else {
            
            // Set values for aerial
            mapView.setMinZoom(1, maxZoom: 20)
            zoom = 1
            angle = 0
            latitudinalDistance = radius * 2
            longitudinalDistance = radius * 2
        }
    }

    func initializeMap() {
        
        // Initialize
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
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
        
        // Start observing
        locationManager.startUpdatingLocation()
    }
    
    func initializeLocationMarker() {
        
        // Initialize
        locationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        locationMarker.appearAnimation = .pop
        locationMarker.map = mapView
    }
    
    func resizedImage(_ image: UIImage, width: Int, height: Int) -> UIImage {
        
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        image.draw(in: rect, blendMode: .normal, alpha: 1.0)
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
    func showCurrentLocation() {
        
        /*
        // Set location marker
        let image = resizedImage(UIImage(named: "Location Marker")!, width: 30, height: 30)
        locationMarker.icon = image
 */

        // Display location marker
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        locationMarker.position = coordinate
        
        // Display current location on the map
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom, bearing: bearing, viewingAngle: angle)
        mapView.camera = camera
        
        // Stop observing
        locationManager.stopUpdatingLocation()
    }
    
    func displaySearchRadius() {
        
        if (searchNearby) {
            return
        }
        
        // Set search radius
        circleCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let circle = GMSCircle(position: circleCenter, radius: radius)
        
        // Draw circle
        circle.fillColor = UIColor(red: 90.0/255, green: 92.0/255, blue: 107.0/255, alpha: 0.1)
        //circle.strokeColor = UIColor.clear
        circle.strokeColor = UIColor(red: 57.0/255, green: 57.0/255, blue: 67.0/255, alpha: 1.0)
        circle.strokeWidth = 0.5
        circle.map = mapView
    }
    
    func setCameraZoom() {
        
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
        if (searchNearby) {
            location = locationMarker.position
        } else {
            location = circleCenter
        }
        
        // Set region
        var coordinate = location
        let region = MKCoordinateRegionMakeWithDistance(coordinate, latitudinalDistance, longitudinalDistance)
        let span = region.span
        
        coordinate.latitude = coordinate.latitude + span.latitudeDelta
        coordinate.longitude = coordinate.longitude + span.longitudeDelta
        
        // Set bounds
        let range = coordinate
        let bounds = GMSCoordinateBounds(coordinate: location, coordinate: range)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 5.0)
        
        // Set camera location
        mapView.moveCamera(update)
        mapView.animate(toLocation: location)
        
        // Animate camera
        if (searchNearby) {
            mapView.animate(toViewingAngle: angle)
            mapView.animate(toZoom: zoom)
        }
    }
    
    func displayPlaces() {
        
        let places = appDelegate.googlePlaces
        
        // Display places on the map
        for place in places {
            let position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let marker = GMSMarker(position: position)
            marker.title = place.name
            marker.snippet = place.address
            //marker.icon = GMSMarker.markerImage(with: UIColor(red: 57.0/255, green: 57.0/255, blue: 67.0/255, alpha: 1.0))
            marker.icon = UIImage(named: "Place Pin")
            marker.map = mapView
        }
    }
}

// MARK: PlaceMapViewController: CLLocationManagerDelegate
extension PlaceMapViewController: CLLocationManagerDelegate {
    
}

// MARK: PlaceMapViewController: GMSMapViewDelegate
extension PlaceMapViewController: GMSMapViewDelegate {
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        // Get current location
        latitude = (mapView.myLocation?.coordinate.latitude)!
        longitude = (mapView.myLocation?.coordinate.longitude)!
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        locationMarker.position = coordinate
        
        // Reset zoom
        setCameraZoom()
        mapView.selectedMarker = nil
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
 
        // Set selected marker image
        mapView.selectedMarker = marker
        marker.icon = UIImage(named: "Place Pin Selected")
        
        // Reposition camera
        mapView.animate(toLocation: marker.position)
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        
        // Reset unselected marker image
        marker.icon = UIImage(named: "Place Pin")
    }
}

