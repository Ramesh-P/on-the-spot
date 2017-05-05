//
//  DocumentViewController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/4/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: DocumentViewController
class DocumentViewController: UIViewController {
    
    // MARK: Properties
    var documentName: String = String()
    var titleFontSize: CGFloat = CGFloat()
    
    // MARK: Outlets
    
    // MARK: Actions
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        getFontSize()
        displayTitle()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

// MARK: extension DocumentViewController
extension DocumentViewController {
    
    // MARK: Class Functions
    func getFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            titleFontSize = Constants.FontSize.Title.phoneSE
        case Constants.ScreenHeight.phone:
            titleFontSize = Constants.FontSize.Title.phone
        case Constants.ScreenHeight.phonePlus:
            titleFontSize = Constants.FontSize.Title.phonePlus
        default:
            break
        }
    }
    
    func displayTitle() {
        
        // Set title to selected place type
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Roboto-Medium", size: titleFontSize)!]
        
        if (documentName == "Credit") {
            self.title = "Acknowledgements & Credits"
        } else if (documentName == "Help") {
            self.title = "User Guide"
        } else if (documentName == "Legal") {
            self.title = "Terms and Conditions"
        }
    }
}

