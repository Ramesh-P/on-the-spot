//
//  PlaceTableViewController.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: PlaceTableViewController
class PlaceTableViewController: UIViewController {
    
    // MARK: Properties
    var nameFontSize: CGFloat = CGFloat()
    var addressFontSize: CGFloat = CGFloat()
    var ratingFontSize: CGFloat = CGFloat()
    var statusFontSize: CGFloat = CGFloat()

    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        getFontSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        /*
        // Show delete button
        PlaceTabBarController.deleteButton.image = UIImage(named: "Delete")
        PlaceTabBarController.deleteButton.isEnabled = true
 */
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

// MARK: extension PlaceTableViewController
extension PlaceTableViewController {
    
    // MARK: Class Functions
    func getFontSize() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Get font size
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            nameFontSize = Constants.FontSize.PlaceTable.Large.phoneSE
            addressFontSize = Constants.FontSize.PlaceTable.Medium.phoneSE
            ratingFontSize = Constants.FontSize.PlaceTable.Small.phoneSE
            statusFontSize = Constants.FontSize.PlaceTable.Small.phoneSE
        case Constants.ScreenHeight.phone:
            nameFontSize = Constants.FontSize.PlaceTable.Large.phone
            addressFontSize = Constants.FontSize.PlaceTable.Medium.phone
            ratingFontSize = Constants.FontSize.PlaceTable.Small.phone
            statusFontSize = Constants.FontSize.PlaceTable.Small.phone
        case Constants.ScreenHeight.phonePlus:
            nameFontSize = Constants.FontSize.PlaceTable.Large.phonePlus
            addressFontSize = Constants.FontSize.PlaceTable.Medium.phonePlus
            ratingFontSize = Constants.FontSize.PlaceTable.Small.phonePlus
            statusFontSize = Constants.FontSize.PlaceTable.Small.phonePlus
        default:
            break
        }
    }
}

// MARK: PlaceTableViewController: UITableViewDataSource, UITableViewDelegate
extension PlaceTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PlaceTabBarController.placeCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Initialize
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! Row
        
        // Set font style
        cell.name.font = UIFont(name: "Roboto-Medium", size: nameFontSize)
        cell.address.font = UIFont(name: "Roboto-Regular", size: addressFontSize)
        cell.rating.font = UIFont(name: "Roboto-Medium", size: ratingFontSize)
        cell.status.font = UIFont(name: "Roboto-Medium", size: statusFontSize)
        
        // Present
        cell.name.text = PlaceTabBarController.placeCollection[indexPath.row].name
        cell.address.text = PlaceTabBarController.placeCollection[indexPath.row].address
        
        let rating = PlaceTabBarController.placeCollection[indexPath.row].rating
        if (rating != 0.0) {
            cell.rating.text = String(rating)
        } else {
            cell.rating.text = "NOT RATED"
        }
        
        let status = PlaceTabBarController.placeCollection[indexPath.row].isOpen
        if (status) {
             cell.status.text = "OPEN"
        } else {
            cell.status.text = "CLOSED"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Get height
        let screenHeight = UIScreen.main.bounds.size.height
        var rowHeight: CGFloat = CGFloat()
        
        // Set row height
        switch screenHeight {
        case Constants.ScreenHeight.phoneSE:
            rowHeight = Constants.RowHeight.phoneSE
        case Constants.ScreenHeight.phone:
            rowHeight = Constants.RowHeight.phone
        case Constants.ScreenHeight.phonePlus:
            rowHeight = Constants.RowHeight.phonePlus
        default:
            break
        }
        
        return rowHeight
    }
}

