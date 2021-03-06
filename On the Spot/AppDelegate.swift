//
//  AppDelegate.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/6/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard
    var searchNearby: Bool = Bool()
    var distanceInMiles: Double = Double()
    var searchRadius: CLLocationDistance = CLLocationDistance()
    var googlePlaces: [GooglePlaces] = [GooglePlaces]()
    let stack = CoreDataStack(modelName: "Model")!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Hide navigation bar border
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        // Hide tab bar border
        UITabBar.appearance().clipsToBounds = true
        
        // Enable Google Mobile Service (GMS)
        GMSServices.provideAPIKey(Google.gmsKey)
        //GMSServices.provideAPIKey(Google.ParameterValues.apiKey)
        
        // Set UI object defaults
        setDefaults()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        stack.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        stack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        stack.saveContext()
    }
    
    // MARK: Application Functions
    func setDefaults() {
        
        // Initialize
        if (defaults.value(forKey: "searchNearby") == nil) {
            defaults.set(true, forKey: "searchNearby")
        }
        
        if (defaults.value(forKey: "distanceInMiles") == nil) {
            defaults.set(5, forKey: "distanceInMiles")
        }
        
        // Set default values for search type & radius
        searchNearby = defaults.bool(forKey: "searchNearby")
        distanceInMiles = defaults.double(forKey: "distanceInMiles")
        searchRadius = distanceInMiles * Constants.metersPerMile
    }
}

