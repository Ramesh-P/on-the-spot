//
//  DocumentViewController+Delegate.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/22/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

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

