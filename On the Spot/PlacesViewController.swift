//
//  PlacesViewController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/6/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: PlacesViewController
class PlacesViewController: UIViewController {
    
    // MARK: Properties
    var addressFontSize: CGFloat = CGFloat()
    var locationFontSize: CGFloat = CGFloat()
    var searchFontSize: CGFloat = CGFloat()
    var placesFontSize: CGFloat = CGFloat()
    var placeholderText: NSAttributedString = NSAttributedString()
    
    // MARK: Outlets
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var places: UICollectionView!
    @IBOutlet weak var locationView: UIView!
    
    // MARK: Actions
    @IBAction func menu(_ sender: UIBarButtonItem) {
        
    }

    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        searchField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications
        subscribeToKeybcardNotifications()
        
        // Layout
        setFontSize()
        setFont()
        setPlaceholderText()
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
    
    // MARK: Class Helpers
    func setFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Set font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            addressFontSize = 13.0
            locationFontSize = 12.0
            searchFontSize = 13.0
            placesFontSize = 11.0
        case Constants.ScreenHeight.phone:
            addressFontSize = 15.0
            locationFontSize = 14.0
            searchFontSize = 15.0
            placesFontSize = 13.0
        case Constants.ScreenHeight.phonePlus:
            addressFontSize = 16.0
            locationFontSize = 15.0
            searchFontSize = 16.0
            placesFontSize = 14.0
        default:
            break
        }
    }
    
    func setFont() {
        
        // Set font
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

