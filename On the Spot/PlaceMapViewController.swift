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
    var placeType: String = String()
    var placeNameFontSize: CGFloat = CGFloat()
    var placeAddressFontSize: CGFloat = CGFloat()
    
    let locationManager: CLLocationManager = CLLocationManager()
    var latitude: Double = Double()
    var longitude: Double = Double()
    var locationMarker: GMSMarker = GMSMarker()
    var circleCenter: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var zoom: Float = Float()
    var radius: CLLocationDistance = CLLocationDistance()
    
    // MARK: Outlets
    @IBOutlet var mapView: GMSMapView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        locationManager.delegate = self
        mapView.delegate = self
        
        initializeMap()
        initializeLocation()
        //initializeLocationMarker()
        showCurrentLocation()
        displaySearchRadius()
        setCameraZoom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Hide delete button
        PlaceTabBarController.deleteButton.image = UIImage(named: "Blank")
        PlaceTabBarController.deleteButton.isEnabled = false
        
        // Initialize
        getFontSize()
        setFontStyle()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

// MARK: extension PlaceMapViewController
extension PlaceMapViewController {
    
    // MARK: Class Functions
    func getFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            placeNameFontSize = Constants.FontSize.Place.Medium.phoneSE
            placeAddressFontSize = Constants.FontSize.Place.Small.phoneSE
        case Constants.ScreenHeight.phone:
            placeNameFontSize = Constants.FontSize.Place.Medium.phone
            placeAddressFontSize = Constants.FontSize.Place.Small.phone
        case Constants.ScreenHeight.phonePlus:
            placeNameFontSize = Constants.FontSize.Place.Medium.phonePlus
            placeAddressFontSize = Constants.FontSize.Place.Small.phonePlus
        default:
            break
        }
    }
    
    func setFontStyle() {
        
        // Set font style
    }
    
    func initializeMap() {
        
        // Initialize
        mapView.animate(toBearing: 0)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.setMinZoom(1, maxZoom: 20)
        zoom = 15.0
        radius = 5 * 1609.34
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
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.camera = camera
        
        // Stop observing
        locationManager.stopUpdatingLocation()
    }
    
    func displaySearchRadius() {
        
        // Set search radius
        circleCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let circle = GMSCircle(position: circleCenter, radius: radius)
        
        // Draw circle
        circle.fillColor = UIColor(red: 90.0/255, green: 92.0/255, blue: 107.0/255, alpha: 0.1)
        circle.strokeColor = UIColor(red: 57.0/255, green: 57.0/255, blue: 67.0/255, alpha: 1.0)
        circle.strokeWidth = 0.5
        circle.map = mapView
    }
    
    func setCameraZoom() {
        
        // Set region
        var coordinate = circleCenter
        let region = MKCoordinateRegionMakeWithDistance(coordinate, radius * 2, radius * 2)
        let span = region.span
        
        coordinate.latitude = coordinate.latitude + span.latitudeDelta
        coordinate.longitude = coordinate.longitude + span.longitudeDelta
        
        // Set bounds
        let range = coordinate
        let bounds = GMSCoordinateBounds(coordinate: circleCenter, coordinate: range)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 5.0)
        
        // Set camera zoom
        mapView.moveCamera(update)
        mapView.animate(toLocation: circleCenter)
    }
}

// MARK: PlaceMapViewController: CLLocationManagerDelegate
extension PlaceMapViewController: CLLocationManagerDelegate {
    
}

// MARK: PlaceMapViewController: GMSMapViewDelegate
extension PlaceMapViewController: GMSMapViewDelegate {
    
}

