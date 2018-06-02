//
//  DriverAnnotaion.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 02/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit
import MapKit


class DriverAnnotaion: NSObject, MKAnnotation {
    
    
   dynamic var coordinate: CLLocationCoordinate2D
    
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, withKey key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    
    func update(annotationPosition annotaion: DriverAnnotaion, withCoordinate coordinate: CLLocationCoordinate2D) {
        
        var location = self.coordinate
        
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        
        UIView.animate(withDuration: 0.2) {
            self.coordinate = location
        }
        
    }
    
    
    
    
    
    
    
}
