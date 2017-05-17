//
//  SettingViewController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/4/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// MARK: SettingViewController
class SettingViewController: UIViewController {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var titleFontSize: CGFloat = CGFloat()
    var messageFontSize: CGFloat = CGFloat()
    var contentFontSize: CGFloat = CGFloat()
    var searchNearby: Bool = Bool()
    var distanceInMiles: Double = Double()
    var searchRadius: CLLocationDistance = CLLocationDistance()
    
    // MARK: Outlets
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var typeDescription: UILabel!
    @IBOutlet var distanceButtons: [UIButton]!
    @IBOutlet weak var credit: UIButton!
    @IBOutlet weak var help: UIButton!
    @IBOutlet weak var legal: UIButton!
    
    // MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Dismiss settings view
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchType(_ sender: UISegmentedControl) {
        
        // Set new search type value
        switch sender.selectedSegmentIndex {
        case 0:
            appDelegate.defaults.set(true, forKey: "searchNearby")
        case 1:
            appDelegate.defaults.set(false, forKey: "searchNearby")
        default:
            break
        }
        appDelegate.searchNearby = appDelegate.defaults.bool(forKey: "searchNearby")
        
        setLayout()
    }
    
    @IBAction func searchDistance(_ sender: UIButton) {
        
        // Set new search radius value
        let mile = Double(sender.tag)
        appDelegate.defaults.set(mile, forKey: "distanceInMiles")
        appDelegate.distanceInMiles = appDelegate.defaults.double(forKey: "distanceInMiles")
        appDelegate.searchRadius = appDelegate.distanceInMiles * Constants.metersPerMile
        
        setLayout()
    }
    
    @IBAction func appCredit(_ sender: UIButton) {
        
        // Show acknowledgements & credits
        let documentName = "Credit"
        self.performSegue(withIdentifier: "toDocumentViewController", sender: documentName)
    }
    
    @IBAction func appHelp(_ sender: UIButton) {
        
        // Show user guide
        let documentName = "Help"
        self.performSegue(withIdentifier: "toDocumentViewController", sender: documentName)
    }
    
    @IBAction func legalTerms(_ sender: UIButton) {
        
        // Show terms and conditions
        let documentName = "Legal"
        self.performSegue(withIdentifier: "toDocumentViewController", sender: documentName)
    }
    
    @IBAction func unwindToSettingViewController(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Initialize
        getFontSize()
        setFontStyle()
        setButtonStyle()
        setLayout()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Show documents
        if (segue.identifier == "toDocumentViewController") {
            let controller = segue.destination as! DocumentViewController
            let documentName = sender as! String
            controller.documentName = documentName
        }
    }
}

