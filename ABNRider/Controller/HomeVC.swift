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
    
    
    @IBOutlet var destTF: UITextField!
    
    @IBOutlet var destCircle: CircularView!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerMapBtn: UIButton!
    
    var delegate: CenterVCDelegate?
    
    var locationMnger: CLLocationManager?
    var regionRadius: CLLocationDistance = 1000
    
    var tableView = UITableView.init()
    
    let locationCellId = "LocationCellID"
    
    var matchingItems = [MKMapItem]()
    var selectedItemPlaceMark: MKPlacemark? = nil
    
    var route: MKRoute!
    
    var currentUserId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        mapView.delegate = self

        locationMnger = CLLocationManager.init()
        locationMnger?.delegate = self
        locationMnger?.desiredAccuracy = kCLLocationAccuracyBest
        
        
        mapView.showsUserLocation = true
        
        checkLocationAuthStatus()

        DataService.shared.Ref_Drivers.observe(.value, with: { (snapshot) in
            self.loadDriversAnnotaionsFromFirebase()
        })
        
        mapView.delegate = self

        
        centerMaponUserLocation()

        destTF.delegate = self
        
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTapTheView(sender:)))
//        self.view.addGestureRecognizer(tap)
//
        currentUserId = Auth.auth().currentUser?.uid
    }

    @objc func onTapTheView(sender: UITapGestureRecognizer) {
        
        animateTableView(shouldShow: false)
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
    
    
    func handleDestCircleView(bgColor: UIColor, borderColor: UIColor) {
        
        UIView.animate(withDuration: 0.2) {
            
            self.destCircle.backgroundColor = bgColor
            self.destCircle.borderColor = borderColor
            
        }
        
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
        } else if let annotation = annotation as? PassengerAnnotation {
            
            let identifier = "passenger"
            var viwww: MKAnnotationView!
            
            viwww = MKAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
            viwww.image = #imageLiteral(resourceName: "currentLocationAnnotation")
            return viwww
        } else if let annot = annotation as? MKPointAnnotation {
            
            let identfier = "destination"
            
            var annView = mapView.dequeueReusableAnnotationView(withIdentifier: identfier)
            
            if annView == nil {
                annView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: identfier)
            } else {
                annView?.annotation = annot
            }
            
            annView?.image = #imageLiteral(resourceName: "destinationAnnotation")
            return annView
            
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        self.centerMapBtn.fadeTo(alphaValue: 1.0, withDuration: 0.2)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let lineRenderer = MKPolylineRenderer.init(overlay: self.route.polyline)
        
        lineRenderer.strokeColor = .orange
        lineRenderer.lineWidth = 5.0
        lineRenderer.lineJoin = .round
        
        return lineRenderer
    }
    
    
    func performSearch() {
        matchingItems.removeAll()
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = destTF.text
        request.region = mapView.region
        
        let search = MKLocalSearch.init(request: request)
        
        search.start { (response, error) in
            
            if error != nil {
                
                print(error.debugDescription)
                
            } else if response?.mapItems.count == 0 {
                
                print("No Result")
                
            } else {
                
                for mapItem in response!.mapItems {
                    
                    self.matchingItems.append(mapItem)
                    self.tableView.reloadData()
                }
            }
            
        }
       
    }
    
    
    func dropPinForPlaceMark(placeMark: MKPlacemark) {
        
        selectedItemPlaceMark = placeMark
        
        for ann in mapView.annotations {
            if ann.isKind(of: MKPointAnnotation.self) {
                mapView.removeAnnotation(ann)
            }
        }
        
        let annotation = MKPointAnnotation.init()
        annotation.coordinate = placeMark.coordinate
        self.mapView.addAnnotation(annotation)
        
    }
    
    func searchMApKitForResultsWithPolyLines(forMapItem mapItem: MKMapItem) {
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapItem
        request.transportType = .automobile

        let directions = MKDirections.init(request: request)
        
        directions.calculate { (response, error) in
            
            if error != nil {
                
                
            } else {
                self.route = response?.routes.first
                self.mapView.add(self.route.polyline)
            }
            
            
        }
    }
    
    
}


extension HomeVC: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        tableView.frame = CGRect.init(x: 20, y: self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.height - 250)
        tableView.layer.cornerRadius = 5.0
//        tableView.layer.masksToBounds = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: locationCellId)
        tableView.dataSource = self
        tableView.tag = 11
        tableView.rowHeight = 60
        tableView.delegate = self

        self.view.addSubview(tableView)
        
        animateTableView(shouldShow: true)
        
        self.handleDestCircleView(bgColor: .red, borderColor: .cyan)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == destTF {
            
            if destTF.text == "" {
                handleDestCircleView(bgColor: .gray, borderColor: .black)
            }else {
                
                handleDestCircleView(bgColor: .red, borderColor: .blue)
            }
            
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == destTF {
            // Perform Search
            performSearch()
            view.endEditing(true)
        }
        
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == destTF {
            
            if destTF.text == "" {
                self.handleDestCircleView(bgColor: .gray, borderColor: .yellow)
            }
        }
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        centerMaponUserLocation()
        self.matchingItems = []
        self.tableView.reloadData()
//        animateTableView(shouldShow: false)
        return true

    }
    
    func animateTableView(shouldShow: Bool) {
        
        if shouldShow {
            
            UIView.animate(withDuration: 0.2) {
                
                self.tableView.frame = CGRect.init(x: 0, y: 250, width: self.view.frame.width, height: self.view.frame.height - 250)

            }
            
        } else {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.tableView.frame = CGRect.init(x: 20, y: self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.height - 250)

            }) { (_) in
                
                for tabView in self.view.subviews {
                    if tabView.tag == 11 {
                        tabView.removeFromSuperview()
                    }
                }
                
                
            }
            
        }
        
        
    }
    
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellId, for: indexPath)
//        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: locationCellId)

        let mapItm = self.matchingItems[indexPath.row]
        cell.textLabel?.text = mapItm.name
        cell.detailTextLabel?.text = mapItm.placemark.title
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let passengerCoordinate = locationMnger?.location?.coordinate
        
        let passengerAnnotation = PassengerAnnotation.init(coordinate: passengerCoordinate!, withKey: currentUserId!)
        self.mapView.addAnnotation(passengerAnnotation)
        destTF.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        let selectedMapItem = self.matchingItems[indexPath.row]
        
        DataService.shared.Ref_Users.child(currentUserId!).updateChildValues(["tripCoordinate":[selectedMapItem.placemark.coordinate.latitude, selectedMapItem.placemark.coordinate.longitude]])
        dropPinForPlaceMark(placeMark: selectedMapItem.placemark)
        searchMApKitForResultsWithPolyLines(forMapItem: selectedMapItem)
        animateTableView(shouldShow: false)
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        view.endEditing(true)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if destTF.text == "" {
            self.animateTableView(shouldShow: false)
        }
        
    }
    
    
    
}








