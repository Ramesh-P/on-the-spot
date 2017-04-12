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
        
        // Layout
        setFontSize()
        setFont()
        setPlaceholderText()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

extension PlacesViewController {
    
    // MARK: Class Functions
    
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

