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
    var documentTitle: String = String()
    var titleFontSize: CGFloat = CGFloat()
    var device: String = String()
    
    // MARK: Outlets
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        webView.delegate = self
        
        // Layout
        getDefaultSize()
        displayTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Layout
        displayDocument(documentName)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

