//
//  GoogleAPIMethods.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/13/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: GoogleAPIMethods
class GoogleAPIMethods: NSObject {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var session = URLSession.shared
    
    // MARK: Initializers
    override init() {
        
        super.init()
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> GoogleAPIMethods {
        
        struct Singleton {
            static var sharedInstance = GoogleAPIMethods()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: Tasks
    func taskForData(_ request: NSMutableURLRequest, completionHandlerForDataTask: @escaping (_ success: Bool, _ error: String?, _ result: AnyObject?) -> Void) -> URLSessionDataTask {
        
        // Step-3, 4: Configure and make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // Guard if there was an error
            guard (error == nil) else {
                completionHandlerForDataTask(false, "There was an error with your request", nil)
                return
            }
            
            // Guard if response is not in success range
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForDataTask(false, "Your request returned a status code other than 2xx", nil)
                return
            }
            
            // Guard if no data was returned
            guard let data = data else {
                completionHandlerForDataTask(false, "No data was returned by the request", nil)
                return
            }
            
            // Step-5, 6: Parse and use the data
            self.parseData(data, completionHandlerForParsedData: completionHandlerForDataTask)
        }
        
        // Step-7: Start the request
        task.resume()
        
        return task
    }
    
    func fetchNearbyPlaces(of type: String, for location: String, completionHandlerForFetchPlaces: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        // Step-1: Set the parameters
        var parameters: [String:Any] = [
            Google.ParameterKeys.type: type,
            Google.ParameterKeys.location: location,
            Google.ParameterKeys.key: Google.ParameterValues.apiKey
        ]
        
        let searchByDistance = appDelegate.searchByDistance
        let searchRadius = appDelegate.searchRadius
        
        if (searchByDistance) {
            parameters[Google.ParameterKeys.rankby] = Google.ParameterValues.distance
        } else {
            parameters[Google.ParameterKeys.rankby] = Google.ParameterValues.prominence
            parameters[Google.ParameterKeys.radius] = searchRadius
        }
        
        // Step-2: Build the URL
        let request = NSMutableURLRequest(url: urlFrom(parameters, withPathExtension: Google.URL.output))
        
        // Make the request
        let _ = taskForData(request) { (success, error, result) in
            
            // Guard if there was an error
            guard (error == nil) else {
                completionHandlerForFetchPlaces(false, error)
                return
            }
            
            if success {
                
                // Guard if there is no status
                guard let status = result?[Google.ResponseKeys.status] as? String else {
                    completionHandlerForFetchPlaces(false, "Place search failed")
                    return
                }
                
                // Check if success
                if (status == Google.ResponseValues.ok) {
                    
                    // If success: parse and get google places detail
                    if (self.appDelegate.googlePlaces.count != 0) {
                        self.appDelegate.googlePlaces.removeAll()
                    }

                    let results = result?[Google.ResponseKeys.results] as! Array<NSDictionary>
                    self.appDelegate.googlePlaces = GooglePlaces.allPlacesFrom(results)
                    completionHandlerForFetchPlaces(true, nil)
                } else if (status == Google.ResponseValues.zeroResults) {
                    completionHandlerForFetchPlaces(false, status)
                } else if (status == Google.ResponseValues.overQueryLimit) {
                    completionHandlerForFetchPlaces(false, "Daily search limit exceeded. Try again tomorrow")
                } else if (status == Google.ResponseValues.requestDenied) {
                    completionHandlerForFetchPlaces(false, "Request denied. Invalid API key")
                } else if (status == Google.ResponseValues.invalidRequest) {
                    completionHandlerForFetchPlaces(false, "Invalid request")
                }
            }
        }
    }
}

// MARK: extension GoogleAPIMethods
private extension GoogleAPIMethods {
    
    func urlFrom(_ parameters: [String:Any], withPathExtension: String? = nil) -> URL {
        
        // Create an URL with path extension
        var components = URLComponents()
        components.scheme = Google.URL.apiScheme
        components.host = Google.URL.apiHost
        components.path = Google.URL.apiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func parseData(_ data: Data, completionHandlerForParsedData: (_ success: Bool, _ error: String?, _ result: AnyObject?) -> Void) {
        
        //Parse the data
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForParsedData(false, "Could not parse the data as JSON", nil)
            return
        }
        
        // Use parsed data
        completionHandlerForParsedData(true, nil, parsedResult)
    }
}

