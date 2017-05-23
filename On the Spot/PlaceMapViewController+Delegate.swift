//
//  PlaceMapViewController+Delegate.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/22/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import MapKit

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

