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

// MARK: PlacesViewController
class PlacesViewController: UIViewController {
    
    // MARK: Properties
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
    
    // MARK: Outlets
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var places: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Actions
    @IBAction func menu(_ sender: UIBarButtonItem) {
        
        // TO DO: Display menu options
    }
    
    @IBAction func places(_ sender: UIBarButtonItem) {
        
        // Dismiss keyboard
        searchBar.resignFirstResponder()
        
        // Show saved places
        let placeType = ""
        self.performSegue(withIdentifier: "toPlaceTabBarController", sender: placeType)
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
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

// MARK: extension PlacesViewController
extension PlacesViewController {
    
    // MARK: Class Functions
    func getGeoLocation() {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Guard if no location was returned
            guard (error == nil) else {
                // TO DO: display error
                return
            }
            
            // Get location address
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let addressDictionary = placemark?.addressDictionary
                let addressArray = (addressDictionary?["FormattedAddressLines"] as? [String])!
                
                // Display address
                self.formattedAddress = addressArray.joined(separator: ", ")
                self.address.text = (self.formattedAddress != "") ? self.formattedAddress : "Unknown Location"
                
                // Display location
                self.location.text = "Location: " + String(format: "%.6f", self.latitude) + ", " + String(format: "%.6f", self.longitude)
                
                // Set style
                self.setFontStyle()
            }
        })
    }
    
    // MARK: Class Helpers
    func getFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            addressFontSize = Constants.FontSize.Places.Large.phoneSE
            locationFontSize = Constants.FontSize.Places.Medium.phoneSE
            searchFontSize = Constants.FontSize.Places.Large.phoneSE
        case Constants.ScreenHeight.phone:
            addressFontSize = Constants.FontSize.Places.Large.phone
            locationFontSize = Constants.FontSize.Places.Medium.phone
            searchFontSize = Constants.FontSize.Places.Large.phone
        case Constants.ScreenHeight.phonePlus:
            addressFontSize = Constants.FontSize.Places.Large.phonePlus
            locationFontSize = Constants.FontSize.Places.Medium.phonePlus
            searchFontSize = Constants.FontSize.Places.Large.phonePlus
        default:
            break
        }
    }
    
    func setFontStyle() {
        
        // Set font style
        address.font = UIFont(name: "Roboto-Regular", size: addressFontSize)
        
        let locationText = NSMutableAttributedString(string: location.text!, attributes: [NSFontAttributeName: UIFont(name: "Roboto-Regular", size: locationFontSize)!])
        locationText.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0), range: NSRange(location:0,length:9))
        location.attributedText = locationText
    }
    
    func setPlaceholderText() {
        
        // Set placeholder text
        let attributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0), NSFontAttributeName: UIFont(name: "Roboto-Regular", size: searchFontSize)!]
        let placeholderText: NSAttributedString = NSAttributedString(string: "Search", attributes: attributes)
        
        let searchField = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchField.attributedPlaceholder = placeholderText
    }
    
    func setPlaceholderImage() {
        
        // Set placeholder image
        let searchField = UISearchBar.appearance()
        searchField.setImage(UIImage(named: "Search"), for: UISearchBarIcon.search, state: UIControlState.normal)
    }
    
    func setCancelButtonAppearance() {
        
        // Set cancel button appearance
        let cancelButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Roboto-Regular", size: searchFontSize)!], for: .normal)
        cancelButton.tintColor = UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0)
    }
    
    func setCellSize() {
        
        // Layout cells for places
        let itemsPerRow: CGFloat = 4.0
        let width = UIScreen.main.bounds.size.width / itemsPerRow
        let height = width * 1.33
        
        let flowLayout = places.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: width, height: height)
    }
    
    func displayError(_ message: String?) {
        
        // Display Error
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: PlacesViewController: UISearchBarDelegate
extension PlacesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        // Reposition search bar on keyboard display
        UIView.animate(withDuration: 0.275, animations: {
            self.view.frame.origin.y = -(self.locationView.frame.size.height) + (UIApplication.shared.statusBarFrame.height) + (self.navigationController?.navigationBar.frame.height)!
        })
        
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // Display keyboard and show cancel button
        searchBar.becomeFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true)
        
        // Display places
        isFiltered = false
        places.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        // Reposition search bar on keyboard dismiss
        UIView.animate(withDuration: 0.275, animations: {
            self.view.frame.origin.y = (UIApplication.shared.statusBarFrame.height) + (self.navigationController?.navigationBar.frame.height)!
        })
        
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        // Hide cance button
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // Dismiss keyboard
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        // Display places
        isFiltered = false
        places.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Dismiss keyboard
        searchBar.text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        searchBar.resignFirstResponder()
        
        // Display places
        isFiltered = true
        places.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Search and filter places
        let searchResult = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (searchResult.isEmpty) {
            isFiltered = false
        } else {
            isFiltered = true
            filteredPlaces = Google.placeTypes.filter { $0.localizedCaseInsensitiveContains(searchResult) }
        }
        
        // Display places
        places.reloadData()
    }
}

// MARK: PlacesViewController: CLLocationManagerDelegate
extension PlacesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // Start tracking location if authorized by user
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Update user current location
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            getGeoLocation()
        }
    }
}

// MARK: PlacesViewController: UICollectionViewDataSource, UICollectionViewDelegate
extension PlacesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Set total cells
        var count: Int = Int()
        
        if (isFiltered) {
            count = filteredPlaces.count
        } else {
            count = Google.placeTypes.count
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! Cell
        var id: String = String()
        var image: String = String()
        
        // Display places
        if (isFiltered) {
            id = String(filteredPlaces[indexPath.row].components(separatedBy: ":").first!)
        } else {
            id = String(indexPath.row)
        }
        
        image = "Place Icon-" + id
        cell.placeIcon.image = UIImage(named: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        var id: String = String()
        var image: String = String()
        
        // Display selected place
        if (isFiltered) {
            id = String(filteredPlaces[indexPath.row].components(separatedBy: ":").first!)
        } else {
            id = String(indexPath.row)
        }
        
        image = "Place Icon-" + id + " Selected"
        cell.placeIcon.image = UIImage(named: image)
        
        // Show selected places
        var placeType: String = String()
        
        if (isFiltered) {
            placeType = String(filteredPlaces[indexPath.row].components(separatedBy: ":").last!)
        } else {
            placeType = String(Google.placeTypes[indexPath.row].components(separatedBy: ":").last!)
        }
        
        let type = (placeType.replacingOccurrences(of: " ", with: "_")).lowercased()
        let location = String(latitude) + "," + String(longitude)
        
        GoogleAPIMethods.sharedInstance().fetchNearbyPlaces(of: type, for: location) { (success, error) in
            
            performUIUpdatesOnMain {
                
                // Dismiss keyboard & reset
                self.searchBar.resignFirstResponder()
                self.searchBarCancelButtonClicked(self.searchBar)
                
                // Display places or error
                if success {
                    self.performSegue(withIdentifier: "toPlaceTabBarController", sender: placeType)
                } else {
                    var errorMessage: String = error!
                    
                    if (errorMessage == Google.ResponseValues.zeroResults) {
                        errorMessage = "There is no " + (placeType).lowercased() + " nearby. Please increase the radius and search again"
                    }
                    
                    self.displayError(errorMessage)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        // Reset unselected place
        if let cell = collectionView.cellForItem(at: indexPath) as? Cell {
            var id: String = String()
            var image: String = String()
            
            // Display selected place
            if (isFiltered) {
                id = String(filteredPlaces[indexPath.row].components(separatedBy: ":").first!)
            } else {
                id = String(indexPath.row)
            }
            
            image = "Place Icon-" + id
            cell.placeIcon.image = UIImage(named: image)
        }
    }
}

