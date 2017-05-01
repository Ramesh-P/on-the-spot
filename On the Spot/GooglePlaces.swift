//
//  GooglePlaces.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/30/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftyJSON

// MARK: GooglePlaces
struct GooglePlaces {
    
    // MARK: Properties
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let isOpen: Bool
    let rating: Double
    
    // MARK: Initializer
    init(dictionary: [String:Any]) {
        
        // Initialize
        let json = JSON(dictionary)
        
        name = json[Google.Places.name].stringValue
        address = json[Google.Places.address].stringValue
        latitude = json[Google.Places.geometry][Google.Places.location][Google.Places.latitude].doubleValue
        longitude = json[Google.Places.geometry][Google.Places.location][Google.Places.longitude].doubleValue
        isOpen = json[Google.Places.open][Google.Places.now].boolValue
        rating = json[Google.Places.rating].doubleValue
    }
    
    // MARK: Class Functions
    static func allPlacesFrom(_ results: Array<NSDictionary>) -> [GooglePlaces] {
        
        var googlePlaces = [GooglePlaces]()
        
        // Iterate through the result array, each place information is a dictionary
        for result in results {
            googlePlaces.append(GooglePlaces(dictionary: result as! [String : Any]))
        }
        
        return googlePlaces
    }
}

