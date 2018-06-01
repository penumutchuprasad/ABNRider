//
//  HomeVC.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 30/05/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit
import MapKit

class HomeVC: UIViewController {
    
    
    
    @IBOutlet var mapView: MKMapView!
    
    var delegate: CenterVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }

    
    
    @IBAction func toggleMenu(_ sender: Any) {
        
        delegate?.toggleLeftPanel()
        
    }
    
    
    @IBAction func onRqstRouteClicked(_ sender: RoundedShadowButton) {
        
        sender.animateButton(shouldLoad: true, withMessage: "OK")
    }
    
    

}



extension HomeVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        print(userLocation.coordinate)
        
    }
    
}
