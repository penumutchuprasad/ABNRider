//
//  HomeVC.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 30/05/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class HomeVC: UIViewController {
    
    
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerMapBtn: UIButton!
    
    var delegate: CenterVCDelegate?
    
    var locationMnger: CLLocationManager?
    var regionRadius: CLLocationDistance = 1000
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        locationMnger = CLLocationManager.init()
        locationMnger?.delegate = self
        locationMnger?.desiredAccuracy = kCLLocationAccuracyBest

        checkLocationAuthStatus()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        DataService.shared.Ref_Drivers.observe(.value, with: { (snapshot) in
            self.loadDriversAnnotaionsFromFirebase()
        })
        
        centerMaponUserLocation()

    }

    
    func checkLocationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
        
            locationMnger?.startUpdatingLocation()
            
        } else {
            
            locationMnger?.requestAlwaysAuthorization()
        }
        
    }
    
    
    func centerMaponUserLocation() {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func loadDriversAnnotaionsFromFirebase() {
                
        DataService.shared.Ref_Drivers.observe(.value, with: { (snapshot) in
            
            if let driverSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for driver in driverSnapshot {
                    
                    if driver.hasChild("userIsDriver") {
                        
                        if driver.hasChild("coordinate") {
                            
                            if driver.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool == true {
                                
                                if let driverDict = driver.value as? [String:Any] {
                                    let crd = driverDict["coordinate"] as? [CLLocationDegrees]
                                    let driverCoordinate = CLLocationCoordinate2D.init(latitude: (crd?.first)!, longitude: (crd?.last)!)
                                    
                                    let annotation = DriverAnnotaion.init(coordinate: driverCoordinate, withKey: driver.key)
                                    //                                self.mapView.addAnnotation(annotation)
                                    
                                    
                                    var driverIsVisible: Bool {
                                        
                                        return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                                            
                                            if let driverAnnotaion = annotation as? DriverAnnotaion {
                                                
                                                if driverAnnotaion.key == driver.key {
                                                    
                                                    driverAnnotaion.update(annotationPosition: driverAnnotaion, withCoordinate: driverCoordinate)
                                                    return true
                                                }
                                                
                                            }
                                            
                                            return false
                                            
                                        })
                                        
                                    }
                                    
                                    if !driverIsVisible {
                                        self.mapView.addAnnotation(annotation)
                                    }
                                    
                                }
                                
                            } else {
                                
                                for annt in self.mapView.annotations {
                                    
                                    if annt.isKind(of: DriverAnnotaion.self) {
                                        
                                        if let annotation = annt as? DriverAnnotaion {
                                            
                                            if annotation.key == driver.key {
                                                
                                                self.mapView.removeAnnotation(annotation)
                                                
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    
                }
                
            }
            
        })
    }
    
    
    
    @IBAction func toggleMenu(_ sender: Any) {
        
        delegate?.toggleLeftPanel()
        
    }
    
    
    @IBAction func onRqstRouteClicked(_ sender: RoundedShadowButton) {
        
        sender.animateButton(shouldLoad: true, withMessage: "OK")
    }
    
    @IBAction func onCenterMapBtnPressed(sender: UIButton) {
    
        self.centerMaponUserLocation()
        sender.fadeTo(alphaValue: 0.0, withDuration: 0.2)
    }
    

}

extension HomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        

        if status == .authorizedAlways {
            self.mapView.showsUserLocation = true
            self.mapView.userTrackingMode = .follow
            
        }else {
            
            checkLocationAuthStatus()

        }
        
    }
    
    
}



extension HomeVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        UpdateService.shared.updateUserLocation(withCoordinate: userLocation.coordinate)
        UpdateService.shared.updateDriverLocation(withCoordinate: userLocation.coordinate)
        
    }
    
    // For Annotaion updation while moving
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if let annotation = annotation as? DriverAnnotaion {
            
            let identifier = "driver"
            var viw: MKAnnotationView!
            
            viw = MKAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
            viw.image = #imageLiteral(resourceName: "driverAnnotation")
            return viw
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        self.centerMapBtn.fadeTo(alphaValue: 1.0, withDuration: 0.2)
        
    }
    
    
}













