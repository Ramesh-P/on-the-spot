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

// MARK: extension SettingViewController
extension SettingViewController {
    
    // MARK: Class Functions

    // MARK: Class Helpers
    func getFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            titleFontSize = Constants.FontSize.Setting.Large.phoneSE
            messageFontSize = Constants.FontSize.Setting.Medium.phoneSE
            contentFontSize = Constants.FontSize.Setting.Large.phoneSE
        case Constants.ScreenHeight.phone:
            titleFontSize = Constants.FontSize.Setting.Large.phone
            messageFontSize = Constants.FontSize.Setting.Medium.phone
            contentFontSize = Constants.FontSize.Setting.Large.phone
        case Constants.ScreenHeight.phonePlus:
            titleFontSize = Constants.FontSize.Setting.Large.phonePlus
            messageFontSize = Constants.FontSize.Setting.Medium.phonePlus
            contentFontSize = Constants.FontSize.Setting.Large.phonePlus
        default:
            break
        }
    }
    
    func setFontStyle() {
        
        // Set font style
        for titleLabel in titleLabels {
            titleLabel.font = UIFont(name: "Roboto-Medium", size: titleFontSize)
        }

        typeSegmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Roboto-Regular", size: contentFontSize)!], for: .normal)
        typeDescription.font = UIFont(name: "Roboto-Regular", size: messageFontSize)
        
        for distanceButton in distanceButtons {
            distanceButton.titleLabel!.font =  UIFont(name: "Roboto-Regular", size: contentFontSize)
        }
        
        credit.titleLabel!.font =  UIFont(name: "Roboto-Regular", size: contentFontSize)
        help.titleLabel!.font =  UIFont(name: "Roboto-Regular", size: contentFontSize)
        legal.titleLabel!.font =  UIFont(name: "Roboto-Regular", size: contentFontSize)
    }
    
    func setButtonStyle() {
        
        // Set button style
        for distanceButton in distanceButtons {
            //distanceButton.layer.cornerRadius = 5
            distanceButton.layer.borderWidth = 1
        }
    }
    
    func setLayout() {
        
        // Initialize to saved/default values
        searchNearby = appDelegate.searchNearby
        distanceInMiles = appDelegate.distanceInMiles
        searchRadius = appDelegate.searchRadius
        
        // Set controls (back) to initial value
        resetUnselectedButton()
        
        if (searchNearby) {
            typeSegmentedControl.selectedSegmentIndex = 0
            searchDescriptionFor(typeSegmentedControl.titleForSegment(at: 0)!)
            disableButton()
        } else {
            let id = Int(distanceInMiles)
            setSelectedButton(id)
            typeSegmentedControl.selectedSegmentIndex = 1
            searchDescriptionFor(typeSegmentedControl.titleForSegment(at: 1)!)
            enableButton()
        }
    }
    
    func searchDescriptionFor(_ title: String) {
        
        // Display search type description
        if (title == "Nearby") {
            typeDescription.text = "Places are searched based on their distance to your current location and not by their ranking."
        } else if (title == "Distance") {
            typeDescription.text = "Places are searched based on their ranking and not by their distance to your current location."
        }
    }
    
    func resetUnselectedButton() {
        
        // Set unselected radius button appearance
        for distanceButton in distanceButtons {
            distanceButton.backgroundColor = UIColor.clear
            distanceButton.layer.borderColor = UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0).cgColor
            distanceButton.setTitleColor(UIColor(red: 228.0/255, green: 227.0/255, blue: 225.0/255, alpha: 1.0), for: .normal)
        }
    }
    
    func setSelectedButton(_ sender: Int) {
        
        // Set selected radius button appearance
        for distanceButton in distanceButtons {
            if (distanceButton.tag == sender) {
                distanceButton.backgroundColor = UIColor(red: 92.0/255, green: 226.0/255, blue: 237.0/255, alpha: 1.0)
                distanceButton.layer.borderColor = UIColor(red: 92.0/255, green: 226.0/255, blue: 237.0/255, alpha: 1.0).cgColor
                distanceButton.setTitleColor(UIColor(red: 69.0/255, green: 71.0/255, blue: 83.0/255, alpha: 1.0), for: .normal)
            }
        }
    }
    
    func enableButton() {
        
        // Enable radius buttons
        for distanceButton in distanceButtons {
            distanceButton.isEnabled = true
            distanceButton.alpha = 1.0
        }
    }
    
    func disableButton() {
        
        // Disable radius buttons
        for distanceButton in distanceButtons {
            distanceButton.isEnabled = false
            distanceButton.alpha = 0.5
        }
    }
}

