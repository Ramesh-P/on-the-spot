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

// MARK: DocumentViewController: UIWebViewDelegate
extension DocumentViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // Open link in Safari
        switch navigationType {
        case .linkClicked:
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        default:
            return true
        }
    }
    
    /*
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
 */
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Display error
        let message = "Unable to display \(documentTitle.lowercased())"
        displayError(message)
    }
}

