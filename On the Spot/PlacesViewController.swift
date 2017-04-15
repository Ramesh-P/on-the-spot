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
    var placesFontSize: CGFloat = CGFloat()
    var placeholderText: NSAttributedString = NSAttributedString()
    let locationManager: CLLocationManager = CLLocationManager()
    var latitude: Double = Double()
    var longitude: Double = Double()
    var formattedAddress: String = String()
    
    // MARK: Outlets
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var places: UICollectionView!
    @IBOutlet weak var locationView: UIView!
    
    // MARK: Actions
    @IBAction func menu(_ sender: UIBarButtonItem) {
        
        // TO DO: Display menu options
    }

    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        searchField.delegate = self
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications
        subscribeToKeybcardNotifications()
        
        // Layout
        getFontSize()
        setFontStyle()
        setPlaceholderText()
        
        // Get authorization to track user location
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Unsubscribe to keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Dismiss keyboard
        view.endEditing(true)
    }
}

extension PlacesViewController {
    
    // MARK: Class Functions
    func subscribeToKeybcardNotifications() {
        
        // Add keyboard notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        // Reposition textfield on keyboard display
        view.frame.origin.y = -(locationView.frame.size.height) + (UIApplication.shared.statusBarFrame.height) + (navigationController?.navigationBar.frame.height)!
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        // Reposition textfield on keyboard dismiss
        view.frame.origin.y = (UIApplication.shared.statusBarFrame.height) + (navigationController?.navigationBar.frame.height)!
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        // Remove keyboard notification observers
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
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
            placesFontSize = Constants.FontSize.Places.Small.phoneSE
        case Constants.ScreenHeight.phone:
            addressFontSize = Constants.FontSize.Places.Large.phone
            locationFontSize = Constants.FontSize.Places.Medium.phone
            searchFontSize = Constants.FontSize.Places.Large.phone
            placesFontSize = Constants.FontSize.Places.Small.phone
        case Constants.ScreenHeight.phonePlus:
            addressFontSize = Constants.FontSize.Places.Large.phonePlus
            locationFontSize = Constants.FontSize.Places.Medium.phonePlus
            searchFontSize = Constants.FontSize.Places.Large.phonePlus
            placesFontSize = Constants.FontSize.Places.Small.phonePlus
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
        
        searchField.font = UIFont(name: "Roboto-Regular", size: searchFontSize)
    }
    
    func setPlaceholderText() {
        
        // Set placeholder text
        let textAttachment = NSTextAttachment(data: nil, ofType: nil)
        textAttachment.image = UIImage(named: "Search")
        placeholderText = NSAttributedString(attachment: textAttachment)
        
        searchField.attributedPlaceholder = placeholderText
    }
}

// MARK: PlacesViewController: UITextFieldDelegate
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

