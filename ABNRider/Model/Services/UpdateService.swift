//
//  UpdateService.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 02/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class UpdateService {
    
    
    static let shared = UpdateService()
    
    
    func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        
        DataService.shared.Ref_Users.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for usr in userSnapshot {
                    
                    if usr.key == Auth.auth().currentUser?.uid {
                        DataService.shared.Ref_Users.child(usr.key).updateChildValues(["coordinate":[coordinate.latitude, coordinate.longitude]])
                    }
                    
                }
                
            }
            
        })
        
    }
    
    
    func updateDriverLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        
        DataService.shared.Ref_Drivers.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let driverSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for driver in driverSnapshot {
                    
                    if driver.key == Auth.auth().currentUser?.uid {
                        
                        if driver.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool == true {
                             DataService.shared.Ref_Drivers.child(driver.key).updateChildValues(["coordinate" : [coordinate.latitude, coordinate.longitude]])
                        }
                       
                    }
                    
                }
                
            }
            
        })
    }
    
    
    
}
