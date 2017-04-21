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
    
    // MARK: Outlets
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var places: UICollectionView!
    
    // MARK: Actions
    @IBAction func menu(_ sender: UIBarButtonItem) {
        
        // TO DO: Display menu options
    }

    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
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
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

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
    
    func setHeaderSize() -> CGSize {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Set header size
        let width: Double = Double(places.frame.size.width)
        var height: Double = Double()
        
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            height = Constants.HeaderHeight.phoneSE
        case Constants.ScreenHeight.phone:
            height = Constants.HeaderHeight.phone
        case Constants.ScreenHeight.phonePlus:
            height = Constants.HeaderHeight.phonePlus
        default:
            break
        }
        
        return CGSize(width: width, height: height)
    }
    
    func setCellSize() {
        
        // Layout cells for places
        let itemsPerRow: CGFloat = 4.0
        let width = UIScreen.main.bounds.size.width / itemsPerRow
        let height = width * 1.33
        
        let flowLayout = places.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: width, height: height)
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
        
        // Show keyboard and cancel button
        searchBar.becomeFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        // Reposition search bar on keyboard dismiss
        UIView.animate(withDuration: 0.275, animations: {
            self.view.frame.origin.y = (UIApplication.shared.statusBarFrame.height) + (self.navigationController?.navigationBar.frame.height)!
        })
        
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        // Hide cance button and show placeholder text
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // Dismiss keyboard
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Dismiss keyboard
        searchBar.resignFirstResponder()
    }
}





// MARK: PlacesViewController: UITextFieldDelegate
/*
extension PlacesViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Clear placeholder text
        searchField.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        // Reset placeholder text
        searchField.text = searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (searchField.text?.isEmpty)! {
            searchField.attributedPlaceholder = placeholderText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Dismiss keyboard
        textField.resignFirstResponder()
        return true
    }
}
 */





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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        // Set total sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Set header with search bar
        if (kind == UICollectionElementKindSectionHeader) {
            let header: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PlaceHeader", for: indexPath)
            
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return setHeaderSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Set total cells
        return 90
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! Cell
        var image: String = String()
        
        // Maintain selected places
        if (cell.isSelected) {
            image = "Place Icon-" + String(indexPath.row) + " Selected"
        } else {
            image = "Place Icon-" + String(indexPath.row)
        }
        
        cell.placeIcon.image = UIImage(named: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Display selected place
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        let image = "Place Icon-" + String(indexPath.row) + " Selected"
        cell.placeIcon.image = UIImage(named: image)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        // Reset unselected place
        if let cell = collectionView.cellForItem(at: indexPath) as? Cell {
            let image = "Place Icon-" + String(indexPath.row)
            cell.placeIcon.image = UIImage(named: image)
        }
    }
}

