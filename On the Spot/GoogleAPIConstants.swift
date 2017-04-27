//
//  GoogleAPIConstants.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/13/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: GoogleAPIConstants
struct Google {
    
    // Mark: GMS
    static let gmsKey = "AIzaSyAgj_qd_rh3aGCgyTgWJnFoSPFC5HgqajU"
    
    // MARK: URLs
    struct URL {
        static let apiScheme = "https"
        static let apiHost = "maps.googleapis.com"
        static let apiPath = "/maps/api/place/nearbysearch"
        static let output = "/json"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let location = "location"
        static let radius = "radius"
        static let rankby = "rankby"
        static let type = "type"
        static let key = "key"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let prominence = "prominence"
        static let distance = "distance"
        static let apiKey = "AIzaSyAX8Qxjv8Nlxb8HQYmPOguj4BKj7LehAx4"
    }
    
    // MARK: Response Keys
    struct ResponseKeys {
        static let status = "status"
        static let results = "results"
        static let attributions = "html_attributions"
    }
    
    // MARK: Response Values
    struct ResponseValues {
        static let ok = "OK"
        static let zeroResults = "ZERO_RESULTS"
        static let overQueryLimit = "OVER_QUERY_LIMIT"
        static let requestDenied = "REQUEST_DENIED"
        static let invalidRequest = "INVALID_REQUEST"
    }
    
    // MARK: Place Types
    static let placeTypes = ["0:Accounting", "1:Airport", "2:Amusement Park", "3:Aquarium", "4:Art Gallery", "5:ATM", "6:Bakery", "7:Bank", "8:Bar", "9:Beauty Salon", "10:Bicycle Store", "11:Book Store", "12:Bowling Alley", "13:Bus Station", "14:Cafe", "15:Campground", "16:Car Dealer", "17:Car Rental", "18:Car Repair", "19:Car Wash", "20:Casino", "21:Cemetery", "22:Church", "23:City Hall", "24:Clothing Store", "25:Convenience Store", "26:Courthouse", "27:Dentist", "28:Department Store", "29:Doctor", "30:Electrician", "31:Electronics Store", "32:Embassy", "33:Fire Station", "34:Florist", "35:Funeral Home", "36:Furniture Store", "37:Gas Station", "38:Gym", "39:Hair Care", "40:Hardware Store", "41:Hindu Temple", "42:Home Goods Store", "43:Hospital", "44:Insurance Agency", "45:Jewelry Store", "46:Laundry", "47:Lawyer", "48:Library", "49:Liquor Store", "50:Local Government Office", "51:Locksmith", "52:Lodging", "53:Meal Delivery", "54:Meal Takeaway", "55:Mosque", "56:Movie Rental", "57:Movie Theater", "58:Moving Company", "59:Museum", "60:Night Club", "61:Painter", "62:Park", "63:Parking", "64:Pet Store", "65:Pharmacy", "66:Physiotherapist", "67:Plumber", "68:Police", "69:Post Office", "70:Real Estate Agency", "71:Restaurant", "72:Roofing Contractor", "73:RV Park", "74:School", "75:Shoe Store", "76:Shopping Mall", "77:Spa", "78:Stadium", "79:Storage", "80:Store", "81:Subway Station", "82:Synagogue", "83:Taxi Stand", "84:Train Station", "85:Transit Station", "86:Travel Agency", "87:University", "88:Veterinary Care", "89:Zoo"]
}

