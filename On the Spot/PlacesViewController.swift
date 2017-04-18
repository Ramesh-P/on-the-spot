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
        setCellSize()
        
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
    
    func setCellSize() {
        
        // Layout cells for places
        let itemsPerRow: CGFloat = 4.0
        let width = UIScreen.main.bounds.size.width / itemsPerRow
        let height = width * 1.33
        
        let flowLayout = places.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: width, height: height)
    }
    
    func displayPlaces(cell: Cell, indexPath: IndexPath) {
        
        // Set image and caption
        switch indexPath.row {
        case 0:
            cell.placeType.text = Constants.PlacesType.type_0.rawValue
        case 1:
            cell.placeType.text = Constants.PlacesType.type_1.rawValue
        case 2:
            cell.placeType.text = Constants.PlacesType.type_2.rawValue
        case 3:
            cell.placeType.text = Constants.PlacesType.type_3.rawValue
        case 4:
            cell.placeType.text = Constants.PlacesType.type_4.rawValue
        case 5:
            cell.placeType.text = Constants.PlacesType.type_5.rawValue
        case 6:
            cell.placeType.text = Constants.PlacesType.type_6.rawValue
        case 7:
            cell.placeType.text = Constants.PlacesType.type_7.rawValue
        case 8:
            cell.placeType.text = Constants.PlacesType.type_8.rawValue
        case 9:
            cell.placeType.text = Constants.PlacesType.type_9.rawValue
        case 10:
            cell.placeType.text = Constants.PlacesType.type_10.rawValue
        case 11:
            cell.placeType.text = Constants.PlacesType.type_11.rawValue
        case 12:
            cell.placeType.text = Constants.PlacesType.type_12.rawValue
        case 13:
            cell.placeType.text = Constants.PlacesType.type_13.rawValue
        case 14:
            cell.placeType.text = Constants.PlacesType.type_14.rawValue
        case 15:
            cell.placeType.text = Constants.PlacesType.type_15.rawValue
        case 16:
            cell.placeType.text = Constants.PlacesType.type_16.rawValue
        case 17:
            cell.placeType.text = Constants.PlacesType.type_17.rawValue
        case 18:
            cell.placeType.text = Constants.PlacesType.type_18.rawValue
        case 19:
            cell.placeType.text = Constants.PlacesType.type_19.rawValue
        case 20:
            cell.placeType.text = Constants.PlacesType.type_20.rawValue
        case 21:
            cell.placeType.text = Constants.PlacesType.type_21.rawValue
        case 22:
            cell.placeType.text = Constants.PlacesType.type_22.rawValue
        case 23:
            cell.placeType.text = Constants.PlacesType.type_23.rawValue
        case 24:
            cell.placeType.text = Constants.PlacesType.type_24.rawValue
        case 25:
            cell.placeType.text = Constants.PlacesType.type_25.rawValue
        case 26:
            cell.placeType.text = Constants.PlacesType.type_26.rawValue
        case 27:
            cell.placeType.text = Constants.PlacesType.type_27.rawValue
        case 28:
            cell.placeType.text = Constants.PlacesType.type_28.rawValue
        case 29:
            cell.placeType.text = Constants.PlacesType.type_29.rawValue
        case 30:
            cell.placeType.text = Constants.PlacesType.type_30.rawValue
        case 31:
            cell.placeType.text = Constants.PlacesType.type_31.rawValue
        case 32:
            cell.placeType.text = Constants.PlacesType.type_32.rawValue
        case 33:
            cell.placeType.text = Constants.PlacesType.type_33.rawValue
        case 34:
            cell.placeType.text = Constants.PlacesType.type_34.rawValue
        case 35:
            cell.placeType.text = Constants.PlacesType.type_35.rawValue
        case 36:
            cell.placeType.text = Constants.PlacesType.type_36.rawValue
        case 37:
            cell.placeType.text = Constants.PlacesType.type_37.rawValue
        case 38:
            cell.placeType.text = Constants.PlacesType.type_38.rawValue
        case 39:
            cell.placeType.text = Constants.PlacesType.type_39.rawValue
        case 40:
            cell.placeType.text = Constants.PlacesType.type_40.rawValue
        case 41:
            cell.placeType.text = Constants.PlacesType.type_41.rawValue
        case 42:
            cell.placeType.text = Constants.PlacesType.type_42.rawValue
        case 43:
            cell.placeType.text = Constants.PlacesType.type_43.rawValue
        case 44:
            cell.placeType.text = Constants.PlacesType.type_44.rawValue
        case 45:
            cell.placeType.text = Constants.PlacesType.type_45.rawValue
        case 46:
            cell.placeType.text = Constants.PlacesType.type_46.rawValue
        case 47:
            cell.placeType.text = Constants.PlacesType.type_47.rawValue
        case 48:
            cell.placeType.text = Constants.PlacesType.type_48.rawValue
        case 49:
            cell.placeType.text = Constants.PlacesType.type_49.rawValue
        case 50:
            cell.placeType.text = Constants.PlacesType.type_50.rawValue
        case 51:
            cell.placeType.text = Constants.PlacesType.type_51.rawValue
        case 52:
            cell.placeType.text = Constants.PlacesType.type_52.rawValue
        case 53:
            cell.placeType.text = Constants.PlacesType.type_53.rawValue
        case 54:
            cell.placeType.text = Constants.PlacesType.type_54.rawValue
        case 55:
            cell.placeType.text = Constants.PlacesType.type_55.rawValue
        case 56:
            cell.placeType.text = Constants.PlacesType.type_56.rawValue
        case 57:
            cell.placeType.text = Constants.PlacesType.type_57.rawValue
        case 58:
            cell.placeType.text = Constants.PlacesType.type_58.rawValue
        case 59:
            cell.placeType.text = Constants.PlacesType.type_59.rawValue
        case 60:
            cell.placeType.text = Constants.PlacesType.type_60.rawValue
        case 61:
            cell.placeType.text = Constants.PlacesType.type_61.rawValue
        case 62:
            cell.placeType.text = Constants.PlacesType.type_62.rawValue
        case 63:
            cell.placeType.text = Constants.PlacesType.type_63.rawValue
        case 64:
            cell.placeType.text = Constants.PlacesType.type_64.rawValue
        case 65:
            cell.placeType.text = Constants.PlacesType.type_65.rawValue
        case 66:
            cell.placeType.text = Constants.PlacesType.type_66.rawValue
        case 67:
            cell.placeType.text = Constants.PlacesType.type_67.rawValue
        case 68:
            cell.placeType.text = Constants.PlacesType.type_68.rawValue
        case 69:
            cell.placeType.text = Constants.PlacesType.type_69.rawValue
        case 70:
            cell.placeType.text = Constants.PlacesType.type_70.rawValue
        case 71:
            cell.placeType.text = Constants.PlacesType.type_71.rawValue
        case 72:
            cell.placeType.text = Constants.PlacesType.type_72.rawValue
        case 73:
            cell.placeType.text = Constants.PlacesType.type_73.rawValue
        case 74:
            cell.placeType.text = Constants.PlacesType.type_74.rawValue
        case 75:
            cell.placeType.text = Constants.PlacesType.type_75.rawValue
        case 76:
            cell.placeType.text = Constants.PlacesType.type_76.rawValue
        case 77:
            cell.placeType.text = Constants.PlacesType.type_77.rawValue
        case 78:
            cell.placeType.text = Constants.PlacesType.type_78.rawValue
        case 79:
            cell.placeType.text = Constants.PlacesType.type_79.rawValue
        case 80:
            cell.placeType.text = Constants.PlacesType.type_80.rawValue
        case 81:
            cell.placeType.text = Constants.PlacesType.type_81.rawValue
        case 82:
            cell.placeType.text = Constants.PlacesType.type_82.rawValue
        case 83:
            cell.placeType.text = Constants.PlacesType.type_83.rawValue
        case 84:
            cell.placeType.text = Constants.PlacesType.type_84.rawValue
        case 85:
            cell.placeType.text = Constants.PlacesType.type_85.rawValue
        case 86:
            cell.placeType.text = Constants.PlacesType.type_86.rawValue
        case 87:
            cell.placeType.text = Constants.PlacesType.type_87.rawValue
        case 88:
            cell.placeType.text = Constants.PlacesType.type_88.rawValue
        case 89:
            cell.placeType.text = Constants.PlacesType.type_89.rawValue
        default:
            break
        }
        
        // Set font style
        cell.placeType.font = UIFont(name: "Roboto-Regular", size: placesFontSize)
        cell.placeType.textColor = UIColor(red: 57.0/255, green: 57.0/255, blue: 67.0/255, alpha: 1.0)
        cell.placeType.sizeToFit()
        cell.placeType.textAlignment = .center
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

// MARK: PlacesViewController: UICollectionViewDataSource, UICollectionViewDelegate
extension PlacesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 90
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! Cell
        
        
        
        //let image = "Place Type-" + String(format: "%03d", indexPath.row)
        
        let image = "Place Icon-" + String(indexPath.row)
        
        
        print(image)
        
        cell.placeIcon.image = UIImage(named: image)
        
        
        
        //displayPlaces(cell: cell, indexPath: indexPath)
        

        
        
        return cell
    }





}

