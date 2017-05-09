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

// MARK: extension DocumentViewController
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

