//
//  PassengerAnnotation.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 02/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit
import MapKit

class PassengerAnnotation: NSObject, MKAnnotation {
    
   dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, withKey key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    
  
    
    
}
