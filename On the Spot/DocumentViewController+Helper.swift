//
//  DocumentViewController+Helper.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/16/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: DocumentViewController+Helper
extension DocumentViewController {
    
    // MARK: Class Functions
    func getDefaultSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get current device & title font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            device = Constants.Device.phoneSE
            titleFontSize = Constants.FontSize.Title.phoneSE
        case Constants.ScreenHeight.phone:
            device = Constants.Device.phone
            titleFontSize = Constants.FontSize.Title.phone
        case Constants.ScreenHeight.phonePlus:
            device = Constants.Device.phonePlus
            titleFontSize = Constants.FontSize.Title.phonePlus
        default:
            break
        }
    }
    
    func displayTitle() {
        
        // Set title to selected place type
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Roboto-Medium", size: titleFontSize)!]
        
        if (documentName == "Credit") {
            documentTitle = "Acknowledgements & Credits"
        } else if (documentName == "Help") {
            documentTitle = "User Guide"
        } else if (documentName == "Legal") {
            documentTitle = "Terms and Conditions"
        }
        
        self.title = documentTitle
    }
    
    func displayDocument(_ name: String) {
        
        let filePath = Bundle.main.url(forResource: name, withExtension: "html")
        let parameter = "?device=\(device)"
        let url = NSURL(string: parameter, relativeTo: filePath)
        
        // Display document
        webView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
    }
    
    func displayError(_ message: String?) {
        
        // Display Error
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

