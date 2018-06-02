//
//  DataService.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    static let shared = DataService()
    
    private var _Ref_DBase = DB_BASE
    private var _Ref_Users = DB_BASE.child("Users")
    private var _Ref_Drivers = DB_BASE.child("Drivers")
    private var _Ref_Trips = DB_BASE.child("Trips")
    
    
    var Ref_Base: DatabaseReference {
        return _Ref_DBase
    }
    
    var Ref_Users: DatabaseReference {
        return _Ref_Users
    }
    
    var Ref_Drivers: DatabaseReference {
        return _Ref_Drivers
    }
    
    var Ref_Trips: DatabaseReference {
        return _Ref_Trips
    }
    
    func createFireBaseDBUser(WithUid uid: String, userData: [String:Any], isDriver: Bool) {
        
        if isDriver {
            Ref_Drivers.child(uid).updateChildValues(userData)
        } else {
            Ref_Users.child(uid).updateChildValues(userData)
        }
        
        
    }
    
    
    
    
    
}
