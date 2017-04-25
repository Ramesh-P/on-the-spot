//
//  GCDBlackBox.swift
//  On the Spot
//
//  Created by Ramesh Parthasarathy on 4/24/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: GCD BlackBox
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    
    DispatchQueue.main.async {
        updates()
    }
}

