//
//  PlaceTableViewController+DataSource.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 5/22/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

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

